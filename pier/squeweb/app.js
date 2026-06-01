(function () {
  "use strict";

  var form = document.getElementById("mkmeta-form");
  var packageFileInput = document.getElementById("packageFile");
  var hashValueInput = document.getElementById("hashValue");
  var packageSizeInput = document.getElementById("packageSize");
  var autoPackageSizeInput = document.getElementById("autoPackageSize");
  var includeZipInput = document.getElementById("includeZip");
  var hashHint = document.getElementById("hashHint");
  var hashStatus = document.getElementById("hashStatus");
  var zipStatus = document.getElementById("zipStatus");
  var errorBox = document.getElementById("errorBox");
  var infoBox = document.getElementById("infoBox");
  var metadataPreview = document.getElementById("metadataPreview");
  var resolvedPreview = document.getElementById("resolvedPreview");
  var profilePreview = document.getElementById("profilePreview");
  var noticePreview = document.getElementById("noticePreview");
  var hashButton = document.getElementById("hashButton");
  var generateButton = document.getElementById("generateButton");
  var downloadMetadataButton = document.getElementById("downloadMetadataButton");
  var downloadZipButton = document.getElementById("downloadZipButton");
  var tabButtons = Array.prototype.slice.call(document.querySelectorAll(".tab-button"));

  var scriptSystemverSelect = document.getElementById("scriptSystemver");
  var scriptStatusText = document.getElementById("scriptStatusText");
  var scriptSummaryHint = document.getElementById("scriptSummaryHint");
  var scriptSummaryPreview = document.getElementById("scriptSummaryPreview");
  var openScriptButton = document.getElementById("openScriptButton");
  var scriptModal = document.getElementById("scriptModal");
  var closeScriptButton = document.getElementById("closeScriptButton");
  var insertTemplateButton = document.getElementById("insertTemplateButton");
  var scriptEditor = document.getElementById("scriptEditor");
  var scriptEditorShell = scriptEditor ? scriptEditor.parentNode : null;
  var scriptEditorStatus = document.getElementById("scriptEditorStatus");
  var scriptAutocomplete = document.getElementById("scriptAutocomplete");
  var scriptChipButtons = Array.prototype.slice.call(document.querySelectorAll(".script-chip"));

  var encoder = new TextEncoder();
  var previewTimer = null;
  var scriptCodeMirror = null;
  var scriptErrorLineHandle = null;
  var autocompleteItems = [];
  var autocompleteState = null;
  var autocompleteActiveIndex = 0;
  var generatedState = {
    metadataText: "",
    resolvedText: "",
    profileText: "",
    noticeText: "",
    metadataBytes: null,
    zipBlob: null
  };

  var KNOWN_VARIABLES = ["systemver", "os", "version", "packagesize"];
  var WRITABLE_VARIABLES = ["os", "version", "packagesize"];
  var FORM_CHANGE_SKIP = {
    packageFile: true,
    includeZip: true,
    autoPackageSize: true,
    scriptSystemver: true
  };
  var SCRIPT_TEMPLATE = [
    'if {systemver} == "xp" then {version} = "2.3.0";',
    'if {systemver} != "xp" then {version} = "2.3.0" else {version} = "2.4.0";',
    'if {systemver} != ("xp","7","8","8.1","10") then {version} = "2.3.0" else {version} = "2.4.0";',
    'if {version} == "2.4.0" then {packagesize} = "3.80 MB";'
  ].join("\n");

  function $(id) {
    return document.getElementById(id);
  }

  function normalizeLineEndings(text) {
    return String(text || "").replace(/\r\n/g, "\n").replace(/\r/g, "\n");
  }

  function trimBlock(text) {
    return normalizeLineEndings(text).replace(/^\s+|\s+$/g, "");
  }

  function normalizeScriptText(text) {
    return normalizeLineEndings(text).replace(/[ \t]+$/gm, "").replace(/^\n+|\n+$/g, "");
  }

  function ensureMultilineEnd(text) {
    var normalized = trimBlock(text);
    if (!normalized) {
      return "";
    }
    if (/::end\s*$/i.test(normalized)) {
      return normalized;
    }
    return normalized + "\n::end";
  }

  function setMessage(target, text) {
    if (!text) {
      target.hidden = true;
      target.textContent = "";
      return;
    }
    target.hidden = false;
    target.textContent = text;
  }

  function clearMessages() {
    setMessage(errorBox, "");
    setMessage(infoBox, "");
  }

  function renderPreviewTexts(metadataText, resolvedText, profileText, noticeText) {
    metadataPreview.textContent = metadataText || "";
    resolvedPreview.textContent = resolvedText || "";
    profilePreview.textContent = profileText || "";
    noticePreview.textContent = noticeText || "";
  }

  function hasCodeMirrorSupport() {
    return !!(window.CodeMirror && typeof window.CodeMirror.fromTextArea === "function");
  }

  function syncScriptTextarea() {
    if (scriptCodeMirror) {
      scriptEditor.value = scriptCodeMirror.getValue();
    }
  }

  function getScriptValue() {
    if (scriptCodeMirror) {
      return scriptCodeMirror.getValue();
    }
    return scriptEditor.value;
  }

  function setScriptValue(text) {
    var nextValue = String(text || "");
    if (scriptCodeMirror) {
      scriptCodeMirror.setValue(nextValue);
      syncScriptTextarea();
      return;
    }
    scriptEditor.value = nextValue;
  }

  function focusScriptEditor() {
    if (scriptCodeMirror) {
      scriptCodeMirror.refresh();
      scriptCodeMirror.focus();
      return;
    }
    scriptEditor.focus();
  }

  function refreshScriptEditorLayout() {
    if (scriptCodeMirror) {
      scriptCodeMirror.refresh();
    }
  }

  function getScriptSelection() {
    var doc;
    var anchor;
    var head;

    if (scriptCodeMirror) {
      doc = scriptCodeMirror.getDoc();
      anchor = doc.getCursor("anchor");
      head = doc.getCursor("head");
      return {
        start: doc.indexFromPos(anchor),
        end: doc.indexFromPos(head)
      };
    }

    return {
      start: scriptEditor.selectionStart,
      end: scriptEditor.selectionEnd
    };
  }

  function setScriptSelection(start, end) {
    var doc;
    var selectionStart = Math.max(0, start || 0);
    var selectionEnd = typeof end === "number" ? Math.max(0, end) : selectionStart;

    if (scriptCodeMirror) {
      doc = scriptCodeMirror.getDoc();
      doc.setSelection(doc.posFromIndex(selectionStart), doc.posFromIndex(selectionEnd));
      return;
    }

    scriptEditor.setSelectionRange(selectionStart, selectionEnd);
  }

  function getScriptCursorCoordinates() {
    var coords;
    var shellRect;

    if (!scriptCodeMirror || !scriptEditorShell) {
      return null;
    }

    coords = scriptCodeMirror.cursorCoords(scriptCodeMirror.getDoc().getCursor(), "page");
    shellRect = scriptEditorShell.getBoundingClientRect();
    return {
      left: coords.left - shellRect.left,
      top: coords.top - shellRect.top,
      bottom: coords.bottom - shellRect.top
    };
  }

  function clearScriptErrorMarker() {
    if (scriptCodeMirror && scriptErrorLineHandle) {
      scriptCodeMirror.removeLineClass(scriptErrorLineHandle, "wrap", "script-error-line");
      scriptErrorLineHandle = null;
    }
  }

  function markScriptErrorLine(error) {
    var lineIndex;

    clearScriptErrorMarker();
    if (!scriptCodeMirror || !error || !error.lineNumber) {
      return;
    }

    lineIndex = Math.max(0, error.lineNumber - 1);
    scriptErrorLineHandle = scriptCodeMirror.getLineHandle(lineIndex);
    if (scriptErrorLineHandle) {
      scriptCodeMirror.addLineClass(scriptErrorLineHandle, "wrap", "script-error-line");
    }
  }

  function initializeCodeMirrorEditor() {
    if (!scriptEditor || !scriptEditorShell || !hasCodeMirrorSupport()) {
      return;
    }

    try {
      scriptCodeMirror = window.CodeMirror.fromTextArea(scriptEditor, {
        mode: "sque",
        lineNumbers: false,
        lineWrapping: false,
        indentUnit: 2,
        tabSize: 2,
        viewportMargin: Infinity,
        scrollbarStyle: "native"
      });
      scriptEditorShell.classList.add("editor-enhanced");
      syncScriptTextarea();
    } catch (_error) {
      scriptCodeMirror = null;
      scriptEditorShell.classList.remove("editor-enhanced");
    }
  }

  function isValidHash(hash) {
    return /^[0-9a-fA-F]{64}$/.test(hash || "");
  }

  function formatFileSize(bytes) {
    var value = Number(bytes || 0);
    var units = ["B", "KB", "MB", "GB", "TB"];
    var unitIndex = 0;

    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex += 1;
    }

    if (unitIndex === 0) {
      return String(Math.round(value)) + " " + units[unitIndex];
    }
    return value.toFixed(value >= 100 ? 0 : value >= 10 ? 1 : 2) + " " + units[unitIndex];
  }

  function getFormData() {
    return {
      packageName: $("packageName").value.trim(),
      version: $("version").value.trim(),
      os: $("os").value.trim(),
      installerName: $("installerName").value.trim(),
      url: $("url").value.trim(),
      profile: trimBlock($("profile").value),
      distributor: $("distributor").value.trim(),
      author: $("author").value.trim(),
      packageSize: $("packageSize").value.trim(),
      hashValue: $("hashValue").value.trim().toUpperCase(),
      notice: $("notice").value,
      defaultOpen: $("defaultOpen").value,
      alias: $("alias").value,
      profileSque: trimBlock($("profileSque").value),
      noticeSque: trimBlock($("noticeSque").value),
      scriptText: normalizeScriptText(getScriptValue()),
      scriptSystemver: scriptSystemverSelect.value
    };
  }

  function appendField(lines, name, value) {
    lines.push("[" + name + "]");
    lines.push(value);
    lines.push("");
  }

  function buildMetadataText(data, scriptText, includeScript) {
    var lines = [];
    var notice = ensureMultilineEnd(data.notice);
    var defaultOpen = ensureMultilineEnd(data.defaultOpen);
    var alias = ensureMultilineEnd(data.alias);
    var normalizedScript = normalizeScriptText(scriptText);

    appendField(lines, "PackageName", data.packageName);
    appendField(lines, "Version", data.version);
    appendField(lines, "OS", data.os);
    appendField(lines, "InstallerName", data.installerName);
    appendField(lines, "URL", data.url);
    appendField(lines, "ProFile", data.profile);
    if (data.author) {
      appendField(lines, "Author", data.author);
    }
    appendField(lines, "Distributor", data.distributor);
    if (notice) {
      appendField(lines, "Notice", notice);
    }
    if (defaultOpen) {
      appendField(lines, "DefaultOpen", defaultOpen);
    }
    if (alias) {
      appendField(lines, "Alias", alias);
    }
    appendField(lines, "HASH", data.hashValue);
    appendField(lines, "PackageSize", data.packageSize);

    if (includeScript && normalizedScript) {
      lines.push("[Script]");
      Array.prototype.push.apply(lines, normalizedScript.split("\n"));
      lines.push("");
    }

    return lines.join("\r\n");
  }

  function createScriptError(lineNumber, column, message, lineText) {
    return {
      lineNumber: lineNumber,
      column: column,
      message: message,
      lineText: lineText
    };
  }

  function isKnownVariable(name) {
    return KNOWN_VARIABLES.indexOf(String(name || "").toLowerCase()) !== -1;
  }

  function isWritableVariable(name) {
    return WRITABLE_VARIABLES.indexOf(String(name || "").toLowerCase()) !== -1;
  }

  function parseScriptLine(lineText, lineNumber) {
    var line = String(lineText || "");
    var index = 0;

    function error(message, position) {
      return {
        ok: false,
        error: createScriptError(lineNumber, position + 1, message, lineText)
      };
    }

    function skipSpaces() {
      while (index < line.length && /\s/.test(line.charAt(index))) {
        index += 1;
      }
    }

    function readKeyword(keyword) {
      var lower = line.slice(index, index + keyword.length).toLowerCase();
      var next = line.charAt(index + keyword.length);
      if (lower !== keyword) {
        return false;
      }
      if (next && !/\s/.test(next)) {
        return false;
      }
      index += keyword.length;
      return true;
    }

    function readVariable(message) {
      var start = index;
      var end;
      var name;

      if (line.charAt(index) !== "{") {
        return error(message || "变量必须写成 {name} 形式。", start);
      }

      end = line.indexOf("}", index + 1);
      if (end === -1) {
        return error("变量缺少右花括号 `}`。", start);
      }

      name = line.slice(index + 1, end).trim();
      if (!name) {
        return error("变量名不能为空。", start);
      }
      if (!isKnownVariable(name)) {
        return error("未定义变量 {" + name + "}。", start);
      }

      index = end + 1;
      return { name: name.toLowerCase() };
    }

    function readOperator() {
      if (line.slice(index, index + 2) === "==") {
        index += 2;
        return "==";
      }
      if (line.slice(index, index + 2) === "!=") {
        index += 2;
        return "!=";
      }
      if (line.charAt(index) === "=") {
        return error("条件比较必须使用 `==` 或 `!=`，不能只写单个 `=`。", index);
      }
      return error("条件比较缺少 `==` 或 `!=`。", index);
    }

    function readQuotedString(message) {
      var start = index;
      var end;

      if (line.charAt(index) !== "\"") {
        return error(message || "这里需要双引号字符串。", start);
      }

      end = index + 1;
      while (end < line.length && line.charAt(end) !== "\"") {
        end += 1;
      }
      if (end >= line.length) {
        return error("字符串缺少结束双引号。", start);
      }

      index = end + 1;
      return { value: line.slice(start + 1, end) };
    }

    function readCompareValues() {
      var values = [];
      var quoted;

      if (line.charAt(index) === "(") {
        index += 1;
        while (index < line.length) {
          skipSpaces();
          if (line.charAt(index) === ")") {
            index += 1;
            break;
          }

          quoted = readQuotedString("集合比较中的每个值都必须用双引号包裹。");
          if (quoted.error) {
            return quoted;
          }
          values.push(quoted.value);

          skipSpaces();
          if (line.charAt(index) === ",") {
            index += 1;
            continue;
          }
          if (line.charAt(index) === ")") {
            index += 1;
            break;
          }
          return error("集合比较必须写成 (\"a\",\"b\") 形式。", index);
        }

        if (!values.length) {
          return error("集合比较不能为空。", index);
        }
        return { values: values, isSet: true };
      }

      quoted = readQuotedString("条件右侧必须是双引号字符串或括号集合。");
      if (quoted.error) {
        return quoted;
      }
      return { values: [quoted.value], isSet: false };
    }

    function readAssignment(keywordName) {
      var target;
      var value;

      skipSpaces();
      target = readVariable(keywordName + " 后面必须跟可写变量。");
      if (target.error) {
        return target;
      }
      if (!isWritableVariable(target.name)) {
        return error("{" + target.name + "} 不能在 Script 中赋值。", index - target.name.length - 2);
      }

      skipSpaces();
      if (line.charAt(index) !== "=") {
        return error("变量赋值必须使用单个 `=`。", index);
      }
      index += 1;
      skipSpaces();

      value = readQuotedString("赋值右侧必须是双引号字符串。");
      if (value.error) {
        return value;
      }

      return {
        target: target.name,
        value: value.value
      };
    }

    skipSpaces();
    if (!line.trim()) {
      return { ok: true, empty: true, lineNumber: lineNumber, raw: lineText };
    }

    if (!readKeyword("if")) {
      return error("只支持单行 `if ... then ... else ...;` 语句。", index);
    }

    skipSpaces();
    var conditionVariable = readVariable("if 后面必须先写条件变量。");
    if (conditionVariable.error) {
      return conditionVariable;
    }

    skipSpaces();
    var operator = readOperator();
    if (operator.error) {
      return operator;
    }

    skipSpaces();
    var compareValues = readCompareValues();
    if (compareValues.error) {
      return compareValues;
    }

    skipSpaces();
    if (!readKeyword("then")) {
      return error("条件后必须写 `then`。", index);
    }

    var thenAction = readAssignment("then");
    if (thenAction.error) {
      return thenAction;
    }

    skipSpaces();
    var elseAction = null;
    if (line.slice(index, index + 4).toLowerCase() === "else" && /\s/.test(line.charAt(index + 4) || "")) {
      index += 4;
      elseAction = readAssignment("else");
      if (elseAction.error) {
        return elseAction;
      }
      skipSpaces();
    }

    if (line.charAt(index) !== ";") {
      return error("每条 Script 语句末尾都必须以分号 `;` 结束。", index);
    }
    index += 1;
    skipSpaces();

    if (index < line.length) {
      return error("分号后不能再跟其他内容。", index);
    }

    return {
      ok: true,
      empty: false,
      lineNumber: lineNumber,
      raw: lineText,
      condition: {
        name: conditionVariable.name,
        operator: operator,
        values: compareValues.values,
        isSet: compareValues.isSet
      },
      thenAction: thenAction,
      elseAction: elseAction
    };
  }

  function parseScriptText(scriptText) {
    var normalized = normalizeScriptText(scriptText);
    var lines = normalized ? normalized.split("\n") : [];
    var rules = [];
    var errors = [];
    var i;
    var parsed;

    for (i = 0; i < lines.length; i += 1) {
      parsed = parseScriptLine(lines[i], i + 1);
      if (parsed.ok && !parsed.empty) {
        rules.push(parsed);
      } else if (!parsed.ok) {
        errors.push(parsed.error || parsed);
      }
    }

    return {
      text: normalized,
      rules: rules,
      errors: errors,
      nonEmptyLineCount: lines.filter(function (line) {
        return !!line.trim();
      }).length
    };
  }

  function buildScriptContext(data) {
    return {
      systemver: String(data.scriptSystemver || "10").toLowerCase(),
      os: data.os || "",
      version: data.version || "",
      packagesize: data.packageSize || ""
    };
  }

  function getContextValue(ctx, name) {
    var key = String(name || "").toLowerCase();
    if (key === "systemver") return ctx.systemver || "";
    if (key === "os") return ctx.os || "";
    if (key === "version") return ctx.version || "";
    if (key === "packagesize") return ctx.packagesize || "";
    return null;
  }

  function setContextValue(ctx, name, value) {
    var key = String(name || "").toLowerCase();
    if (key === "os") ctx.os = value;
    if (key === "version") ctx.version = value;
    if (key === "packagesize") ctx.packagesize = value;
  }

  function evaluateRule(rule, ctx) {
    var left = String(getContextValue(ctx, rule.condition.name)).toLowerCase();
    var values = rule.condition.values.map(function (item) {
      return String(item).toLowerCase();
    });
    var matched = values.indexOf(left) !== -1;
    var conditionTrue = rule.condition.operator === "==" ? matched : !matched;

    if (conditionTrue) {
      setContextValue(ctx, rule.thenAction.target, rule.thenAction.value);
      return true;
    }
    if (rule.elseAction) {
      setContextValue(ctx, rule.elseAction.target, rule.elseAction.value);
    }
    return false;
  }

  function evaluateScript(data) {
    var parsed = parseScriptText(data.scriptText);
    var ctx = buildScriptContext(data);
    var applied = 0;
    var i;

    if (!parsed.errors.length) {
      for (i = 0; i < parsed.rules.length; i += 1) {
        if (evaluateRule(parsed.rules[i], ctx)) {
          applied += 1;
        }
      }
    }

    return {
      parsed: parsed,
      context: ctx,
      appliedCount: applied
    };
  }

  function interpolateText(text, ctx) {
    return String(text || "").replace(/\{([a-z0-9_]+)\}/ig, function (match, name) {
      var value = getContextValue(ctx, name);
      return value === null ? match : value;
    });
  }

  function buildResolvedData(data, evaluation) {
    var ctx = evaluation.context;
    return {
      packageName: interpolateText(data.packageName, ctx),
      version: ctx.version,
      os: ctx.os,
      installerName: interpolateText(data.installerName, ctx),
      url: interpolateText(data.url, ctx),
      profile: interpolateText(data.profile, ctx),
      distributor: interpolateText(data.distributor, ctx),
      author: interpolateText(data.author, ctx),
      packageSize: ctx.packagesize,
      hashValue: interpolateText(data.hashValue, ctx),
      notice: interpolateText(data.notice, ctx),
      defaultOpen: interpolateText(data.defaultOpen, ctx),
      alias: interpolateText(data.alias, ctx)
    };
  }

  function formatScriptError(error) {
    return "第 " + error.lineNumber + " 行，第 " + error.column + " 列: " + error.message;
  }

  function buildResolvedPreview(data, evaluation) {
    var summaryLines;

    if (evaluation.parsed.errors.length) {
      summaryLines = evaluation.parsed.errors.map(formatScriptError);
      return [
        "Script 语法错误，无法生成解析结果：",
        "",
        summaryLines.join("\n")
      ].join("\n");
    }

    return buildMetadataText(buildResolvedData(data, evaluation), "", false);
  }

  function renderScriptSummary(data, evaluation) {
    var normalized = normalizeScriptText(data.scriptText);
    var context = evaluation.context;
    var firstError;

    clearScriptErrorMarker();
    scriptSummaryPreview.textContent = normalized || "未设置任何 Script 规则。";

    if (!normalized) {
      scriptStatusText.textContent = "未启用";
      scriptSummaryHint.textContent = "未填写 Script 规则时，将直接使用表单字段原值。";
      scriptEditorStatus.textContent = "未启用 Script。";
      return;
    }

    if (evaluation.parsed.errors.length) {
      firstError = evaluation.parsed.errors[0];
      markScriptErrorLine(firstError);
      scriptStatusText.textContent = "语法错误";
      scriptSummaryHint.textContent = formatScriptError(firstError);
      scriptEditorStatus.textContent = "检测到 " + evaluation.parsed.errors.length + " 个错误，生成会被阻止。";
      return;
    }

    scriptStatusText.textContent = "有效 " + evaluation.parsed.rules.length + " 条";
    scriptSummaryHint.textContent = "模拟 " + context.systemver + " 后：os=" + context.os + "，version=" + context.version + "，packagesize=" + context.packagesize;
    scriptEditorStatus.textContent = "Script 语法正确，已按模拟 systemver 生成解析结果。";
  }

  function buildPreviewPayload(data) {
    var evaluation = evaluateScript(data);
    var metadataText = buildMetadataText(data, data.scriptText, true);
    var profileText = data.profileSque ? normalizeLineEndings(data.profileSque).replace(/\n/g, "\r\n") : "";
    var noticeText = data.noticeSque ? ensureMultilineEnd(data.noticeSque).replace(/\n/g, "\r\n") : "";

    renderScriptSummary(data, evaluation);

    return {
      metadataText: metadataText,
      resolvedText: buildResolvedPreview(data, evaluation),
      profileText: profileText,
      noticeText: noticeText,
      evaluation: evaluation
    };
  }

  function refreshPreviewOnly() {
    var preview = buildPreviewPayload(getFormData());
    renderPreviewTexts(preview.metadataText, preview.resolvedText, preview.profileText, preview.noticeText);
  }

  function schedulePreviewRefresh() {
    if (previewTimer) {
      clearTimeout(previewTimer);
    }
    previewTimer = setTimeout(function () {
      previewTimer = null;
      refreshPreviewOnly();
    }, 500);
  }

  function disableGeneratedDownloads() {
    generatedState.metadataBytes = null;
    generatedState.zipBlob = null;
    downloadMetadataButton.disabled = true;
    downloadZipButton.disabled = true;
  }

  function invalidateGeneratedState() {
    if (previewTimer) {
      clearTimeout(previewTimer);
      previewTimer = null;
    }
    if (!generatedState.metadataText && !generatedState.zipBlob && !generatedState.profileText && !generatedState.noticeText) {
      schedulePreviewRefresh();
      return;
    }
    disableGeneratedDownloads();
    hashStatus.textContent = "需重新生成";
    zipStatus.textContent = includeZipInput.checked ? "需重新生成" : "未启用";
    setMessage(infoBox, "字段已修改，请重新生成。");
    schedulePreviewRefresh();
  }

  function validateData(data) {
    var missing = [];
    var evaluation;

    if (!data.packageName) missing.push("PackageName");
    if (!data.version) missing.push("Version");
    if (!data.os) missing.push("OS");
    if (!data.installerName) missing.push("InstallerName");
    if (!data.url) missing.push("URL");
    if (!data.profile) missing.push("ProFile");
    if (!data.distributor) missing.push("Distributor");
    if (!data.packageSize) missing.push("PackageSize");
    if (!data.hashValue) missing.push("HASH");

    if (missing.length) {
      throw new Error("缺少必填字段: " + missing.join(", "));
    }

    if (!isValidHash(data.hashValue)) {
      throw new Error("HASH 必须是 64 位十六进制字符。");
    }

    evaluation = evaluateScript(data);
    if (evaluation.parsed.errors.length) {
      markScriptErrorLine(evaluation.parsed.errors[0]);
      throw new Error("Script 语法错误: " + formatScriptError(evaluation.parsed.errors[0]));
    }

    return evaluation;
  }

  function updatePreviewState(state, includeZip) {
    renderPreviewTexts(state.metadataText, state.resolvedText, state.profileText, state.noticeText);
    hashStatus.textContent = "就绪";
    zipStatus.textContent = includeZip ? (state.zipBlob ? "已生成" : "待生成") : "未启用";
    downloadMetadataButton.disabled = !state.metadataText;
    downloadZipButton.disabled = !includeZip || !state.zipBlob;
  }

  function downloadBlob(blob, fileName) {
    var url = URL.createObjectURL(blob);
    var anchor = document.createElement("a");
    anchor.href = url;
    anchor.download = fileName;
    document.body.appendChild(anchor);
    anchor.click();
    document.body.removeChild(anchor);
    setTimeout(function () {
      URL.revokeObjectURL(url);
    }, 1000);
  }

  function getCurrentDosDateTime() {
    var now = new Date();
    var year = now.getFullYear();
    if (year < 1980) {
      year = 1980;
    }

    return {
      time: ((now.getHours() & 31) << 11) | ((now.getMinutes() & 63) << 5) | (Math.floor(now.getSeconds() / 2) & 31),
      date: (((year - 1980) & 127) << 9) | (((now.getMonth() + 1) & 15) << 5) | (now.getDate() & 31)
    };
  }

  function crc32(bytes) {
    var table = crc32.table;
    var crc = 0 ^ -1;
    var i;

    if (!table) {
      table = [];
      for (i = 0; i < 256; i += 1) {
        var c = i;
        var j;
        for (j = 0; j < 8; j += 1) {
          c = (c & 1) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
        }
        table[i] = c >>> 0;
      }
      crc32.table = table;
    }

    for (i = 0; i < bytes.length; i += 1) {
      crc = (crc >>> 8) ^ table[(crc ^ bytes[i]) & 0xFF];
    }

    return (crc ^ -1) >>> 0;
  }

  function writeUint16(view, offset, value) {
    view.setUint16(offset, value & 0xFFFF, true);
  }

  function writeUint32(view, offset, value) {
    view.setUint32(offset, value >>> 0, true);
  }

  function buildZip(entries) {
    var localParts = [];
    var centralParts = [];
    var offset = 0;
    var centralSize = 0;
    var i;
    var dosStamp = getCurrentDosDateTime();

    for (i = 0; i < entries.length; i += 1) {
      var entry = entries[i];
      var nameBytes = encoder.encode(entry.name);
      var contentBytes = entry.bytes;
      var localHeader = new Uint8Array(30 + nameBytes.length);
      var localView = new DataView(localHeader.buffer);
      var centralHeader = new Uint8Array(46 + nameBytes.length);
      var centralView = new DataView(centralHeader.buffer);
      var crc = crc32(contentBytes);

      writeUint32(localView, 0, 0x04034b50);
      writeUint16(localView, 4, 20);
      writeUint16(localView, 6, 0);
      writeUint16(localView, 8, 0);
      writeUint16(localView, 10, dosStamp.time);
      writeUint16(localView, 12, dosStamp.date);
      writeUint32(localView, 14, crc);
      writeUint32(localView, 18, contentBytes.length);
      writeUint32(localView, 22, contentBytes.length);
      writeUint16(localView, 26, nameBytes.length);
      writeUint16(localView, 28, 0);
      localHeader.set(nameBytes, 30);

      writeUint32(centralView, 0, 0x02014b50);
      writeUint16(centralView, 4, 20);
      writeUint16(centralView, 6, 20);
      writeUint16(centralView, 8, 0);
      writeUint16(centralView, 10, 0);
      writeUint16(centralView, 12, dosStamp.time);
      writeUint16(centralView, 14, dosStamp.date);
      writeUint32(centralView, 16, crc);
      writeUint32(centralView, 20, contentBytes.length);
      writeUint32(centralView, 24, contentBytes.length);
      writeUint16(centralView, 28, nameBytes.length);
      writeUint16(centralView, 30, 0);
      writeUint16(centralView, 32, 0);
      writeUint16(centralView, 34, 0);
      writeUint16(centralView, 36, 0);
      writeUint32(centralView, 38, 0);
      writeUint32(centralView, 42, offset);
      centralHeader.set(nameBytes, 46);

      localParts.push(localHeader, contentBytes);
      centralParts.push(centralHeader);
      offset += localHeader.length + contentBytes.length;
      centralSize += centralHeader.length;
    }

    var endHeader = new Uint8Array(22);
    var endView = new DataView(endHeader.buffer);
    writeUint32(endView, 0, 0x06054b50);
    writeUint16(endView, 4, 0);
    writeUint16(endView, 6, 0);
    writeUint16(endView, 8, entries.length);
    writeUint16(endView, 10, entries.length);
    writeUint32(endView, 12, centralSize);
    writeUint32(endView, 16, offset);
    writeUint16(endView, 20, 0);

    return new Blob(localParts.concat(centralParts, [endHeader]), { type: "application/zip" });
  }

  function rightRotate(value, amount) {
    return (value >>> amount) | (value << (32 - amount));
  }

  function sha256Fallback(arrayBuffer) {
    var words = [];
    var bytes = new Uint8Array(arrayBuffer);
    var bitLength = bytes.length * 8;
    var hash = [
      0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
      0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    ];
    var k = [
      0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
      0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
      0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
      0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
      0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
      0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
      0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
      0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
      0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
      0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
      0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
      0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
      0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
      0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
      0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
      0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
    ];
    var i;

    for (i = 0; i < bytes.length; i += 1) {
      words[i >> 2] |= bytes[i] << ((3 - (i % 4)) * 8);
    }
    words[bitLength >> 5] |= 0x80 << (24 - (bitLength % 32));
    words[(((bitLength + 64) >> 9) << 4) + 15] = bitLength;

    for (i = 0; i < words.length; i += 16) {
      var w = [];
      var a = hash[0];
      var b = hash[1];
      var c = hash[2];
      var d = hash[3];
      var e = hash[4];
      var f = hash[5];
      var g = hash[6];
      var h = hash[7];
      var j;

      for (j = 0; j < 64; j += 1) {
        if (j < 16) {
          w[j] = words[i + j] | 0;
        } else {
          var gamma0x = w[j - 15];
          var gamma1x = w[j - 2];
          var gamma0 = rightRotate(gamma0x, 7) ^ rightRotate(gamma0x, 18) ^ (gamma0x >>> 3);
          var gamma1 = rightRotate(gamma1x, 17) ^ rightRotate(gamma1x, 19) ^ (gamma1x >>> 10);
          w[j] = (((w[j - 16] + gamma0) | 0) + ((w[j - 7] + gamma1) | 0)) | 0;
        }

        var ch = (e & f) ^ (~e & g);
        var maj = (a & b) ^ (a & c) ^ (b & c);
        var sigma0 = rightRotate(a, 2) ^ rightRotate(a, 13) ^ rightRotate(a, 22);
        var sigma1 = rightRotate(e, 6) ^ rightRotate(e, 11) ^ rightRotate(e, 25);
        var t1 = (((((h + sigma1) | 0) + ((ch + k[j]) | 0)) | 0) + w[j]) | 0;
        var t2 = (sigma0 + maj) | 0;

        h = g;
        g = f;
        f = e;
        e = (d + t1) | 0;
        d = c;
        c = b;
        b = a;
        a = (t1 + t2) | 0;
      }

      hash[0] = (hash[0] + a) | 0;
      hash[1] = (hash[1] + b) | 0;
      hash[2] = (hash[2] + c) | 0;
      hash[3] = (hash[3] + d) | 0;
      hash[4] = (hash[4] + e) | 0;
      hash[5] = (hash[5] + f) | 0;
      hash[6] = (hash[6] + g) | 0;
      hash[7] = (hash[7] + h) | 0;
    }

    return hash.map(function (value) {
      return ("00000000" + (value >>> 0).toString(16)).slice(-8);
    }).join("").toUpperCase();
  }

  async function computeHashFromFile(file) {
    var buffer = await file.arrayBuffer();
    if (window.crypto && window.crypto.subtle && typeof window.crypto.subtle.digest === "function") {
      try {
        var digest = await window.crypto.subtle.digest("SHA-256", buffer);
        return Array.prototype.map.call(new Uint8Array(digest), function (item) {
          return item.toString(16).padStart(2, "0");
        }).join("").toUpperCase();
      } catch (_error) {
        return sha256Fallback(buffer);
      }
    }
    return sha256Fallback(buffer);
  }

  async function refreshHash() {
    var file = packageFileInput.files && packageFileInput.files[0];

    if (!file) {
      throw new Error("请先选择安装包文件。");
    }

    hashStatus.textContent = "计算中...";
    hashHint.textContent = "正在计算 SHA-256，请稍候。";
    hashButton.disabled = true;

    try {
      var hash = await computeHashFromFile(file);
      if (previewTimer) {
        clearTimeout(previewTimer);
        previewTimer = null;
      }
      hashValueInput.value = hash;
      disableGeneratedDownloads();
      refreshPreviewOnly();
      hashStatus.textContent = "已计算";
      hashHint.textContent = "SHA-256 已计算完成。";
      zipStatus.textContent = includeZipInput.checked ? "需重新生成" : "未启用";
      setMessage(infoBox, "已从文件计算 SHA-256，请重新生成下载内容。");
      return hash;
    } finally {
      hashButton.disabled = false;
    }
  }

  async function generateAll() {
    clearMessages();
    setMessage(infoBox, "正在生成预览...");
    generateButton.disabled = true;

    try {
      var data = getFormData();
      validateData(data);

      var preview = buildPreviewPayload(data);
      var metadataBytes = encoder.encode(preview.metadataText);
      var zipBlob = null;

      if (includeZipInput.checked) {
        var entries = [{ name: "metadata.sque", bytes: metadataBytes }];
        if (preview.profileText) {
          entries.push({ name: "profile.sque", bytes: encoder.encode(preview.profileText) });
        }
        if (preview.noticeText) {
          entries.push({ name: "notice.sque", bytes: encoder.encode(preview.noticeText) });
        }
        zipBlob = buildZip(entries);
      }

      generatedState.metadataText = preview.metadataText;
      generatedState.resolvedText = preview.resolvedText;
      generatedState.profileText = preview.profileText;
      generatedState.noticeText = preview.noticeText;
      generatedState.metadataBytes = metadataBytes;
      generatedState.zipBlob = zipBlob;

      updatePreviewState(generatedState, includeZipInput.checked);
      setMessage(infoBox, includeZipInput.checked ? "预览、解析结果和 ZIP 已生成。" : "预览和解析结果已生成。");
    } finally {
      generateButton.disabled = false;
    }
  }

  function buildAutocompleteItems(tokenType, query) {
    var lowered = String(query || "").toLowerCase();
    var baseItems;

    if (tokenType === "variable") {
      baseItems = [
        { label: "{systemver}", insert: "{systemver}" },
        { label: "{os}", insert: "{os}" },
        { label: "{version}", insert: "{version}" },
        { label: "{packagesize}", insert: "{packagesize}" }
      ];
      return baseItems.filter(function (item) {
        return item.label.toLowerCase().indexOf("{" + lowered) === 0;
      });
    }

    if (tokenType === "keyword") {
      baseItems = [
        { label: "if", insert: "if " },
        { label: "then", insert: "then " },
        { label: "else", insert: "else " }
      ];
      return baseItems.filter(function (item) {
        return item.label.toLowerCase().indexOf(lowered) === 0;
      });
    }

    if (tokenType === "template") {
      return [
        { label: "XP 版本重载", insert: 'if {systemver} == "xp" then {version} = "2.3.0";' },
        { label: "带 else 分支", insert: 'if {systemver} != "xp" then {version} = "2.3.0" else {version} = "2.4.0";' },
        { label: "集合比较", insert: 'if {systemver} != ("xp","7","8","8.1","10") then {version} = "2.3.0" else {version} = "2.4.0";' }
      ];
    }

    return [];
  }

  function detectAutocompleteState() {
    var value = getScriptValue();
    var cursor = getScriptSelection().end;
    var before = value.slice(0, cursor);
    var variableMatch = before.match(/\{[a-z]*$/i);
    var keywordMatch = before.match(/(?:^|[\s(,;])([a-z]{1,10})$/i);

    if (variableMatch) {
      return {
        type: "variable",
        query: variableMatch[0].slice(1),
        start: cursor - variableMatch[0].length,
        end: cursor
      };
    }

    if (!before.trim()) {
      return {
        type: "template",
        query: "",
        start: cursor,
        end: cursor
      };
    }

    if (keywordMatch) {
      return {
        type: "keyword",
        query: keywordMatch[1],
        start: cursor - keywordMatch[1].length,
        end: cursor
      };
    }

    return null;
  }

  function hideAutocomplete() {
    autocompleteItems = [];
    autocompleteState = null;
    autocompleteActiveIndex = 0;
    scriptAutocomplete.hidden = true;
    scriptAutocomplete.innerHTML = "";
    scriptAutocomplete.style.left = "";
    scriptAutocomplete.style.top = "";
    scriptAutocomplete.style.bottom = "";
  }

  function positionAutocomplete() {
    var coords = getScriptCursorCoordinates();
    var left;
    var top;

    if (!coords || !scriptEditorShell) {
      scriptAutocomplete.style.left = "14px";
      scriptAutocomplete.style.top = "";
      scriptAutocomplete.style.bottom = "14px";
      return;
    }

    left = Math.max(12, Math.min(coords.left + 8, scriptEditorShell.clientWidth - scriptAutocomplete.offsetWidth - 12));
    top = Math.max(12, Math.min(coords.bottom + 8, scriptEditorShell.clientHeight - scriptAutocomplete.offsetHeight - 12));
    scriptAutocomplete.style.left = left + "px";
    scriptAutocomplete.style.top = top + "px";
    scriptAutocomplete.style.bottom = "auto";
  }

  function renderAutocomplete() {
    var items;

    autocompleteState = detectAutocompleteState();
    if (!autocompleteState) {
      hideAutocomplete();
      return;
    }

    items = buildAutocompleteItems(autocompleteState.type, autocompleteState.query);
    if (!items.length) {
      hideAutocomplete();
      return;
    }

    autocompleteItems = items;
    autocompleteActiveIndex = Math.min(autocompleteActiveIndex, items.length - 1);
    scriptAutocomplete.innerHTML = "";
    items.forEach(function (item, index) {
      var button = document.createElement("button");
      button.type = "button";
      button.className = "script-autocomplete-item" + (index === autocompleteActiveIndex ? " active" : "");
      button.textContent = item.label;
      button.addEventListener("mousedown", function (event) {
        event.preventDefault();
        applyAutocompleteItem(index);
      });
      scriptAutocomplete.appendChild(button);
    });
    scriptAutocomplete.hidden = false;
    positionAutocomplete();
  }

  function applyAutocompleteItem(index) {
    var item = autocompleteItems[index];
    var value;
    var before;
    var after;
    var insertText;
    var cursor;

    if (!item || !autocompleteState) {
      return;
    }

    value = getScriptValue();
    before = value.slice(0, autocompleteState.start);
    after = value.slice(autocompleteState.end);
    insertText = item.insert;
    setScriptValue(before + insertText + after);
    cursor = before.length + insertText.length;
    setScriptSelection(cursor, cursor);
    focusScriptEditor();
    hideAutocomplete();
    invalidateGeneratedState();
    clearMessages();
  }

  function insertTextAtCursor(text) {
    var value = getScriptValue();
    var selection = getScriptSelection();
    var start = selection.start;
    var end = selection.end;
    var nextValue = value.slice(0, start) + text + value.slice(end);
    var cursor = start + text.length;

    setScriptValue(nextValue);
    setScriptSelection(cursor, cursor);
    focusScriptEditor();
    invalidateGeneratedState();
    clearMessages();
    renderAutocomplete();
  }

  function openScriptModal() {
    scriptModal.hidden = false;
    document.body.classList.add("script-modal-open");
    setTimeout(function () {
      refreshScriptEditorLayout();
      focusScriptEditor();
      renderAutocomplete();
    }, 0);
  }

  function closeScriptModal() {
    scriptModal.hidden = true;
    document.body.classList.remove("script-modal-open");
    hideAutocomplete();
  }

  function handleScriptEditorInput() {
    syncScriptTextarea();
    invalidateGeneratedState();
    clearMessages();
    renderAutocomplete();
  }

  function handleScriptEditorBlur() {
    setTimeout(function () {
      if (!scriptAutocomplete.contains(document.activeElement)) {
        hideAutocomplete();
      }
    }, 100);
  }

  function handleScriptEditorKeydown(event) {
    if (event.key === "Tab" && scriptAutocomplete.hidden) {
      event.preventDefault();
      insertTextAtCursor("  ");
      return;
    }

    if (scriptAutocomplete.hidden) {
      return;
    }

    if (event.key === "ArrowDown") {
      event.preventDefault();
      autocompleteActiveIndex = (autocompleteActiveIndex + 1) % autocompleteItems.length;
      renderAutocomplete();
    } else if (event.key === "ArrowUp") {
      event.preventDefault();
      autocompleteActiveIndex = (autocompleteActiveIndex - 1 + autocompleteItems.length) % autocompleteItems.length;
      renderAutocomplete();
    } else if (event.key === "Enter" || event.key === "Tab") {
      event.preventDefault();
      applyAutocompleteItem(autocompleteActiveIndex);
    } else if (event.key === "Escape") {
      hideAutocomplete();
    }
  }

  initializeCodeMirrorEditor();

  packageFileInput.addEventListener("change", function () {
    var file = packageFileInput.files && packageFileInput.files[0];
    invalidateGeneratedState();
    clearMessages();

    if (!file) {
      hashHint.textContent = "选安装包文件后可自动计算 SHA-256。";
      return;
    }

    hashHint.textContent = "已选择: " + file.name;
    hashStatus.textContent = "待计算";

    if (autoPackageSizeInput.checked) {
      packageSizeInput.value = formatFileSize(file.size);
    }
  });

  hashButton.addEventListener("click", function () {
    clearMessages();
    refreshHash().catch(function (error) {
      hashStatus.textContent = "失败";
      setMessage(errorBox, error.message);
    });
  });

  generateButton.addEventListener("click", function () {
    generateAll().catch(function (error) {
      setMessage(errorBox, error.message);
      setMessage(infoBox, "");
      zipStatus.textContent = includeZipInput.checked ? "失败" : "未启用";
    });
  });

  downloadMetadataButton.addEventListener("click", function () {
    if (!generatedState.metadataBytes) {
      return;
    }
    downloadBlob(new Blob([generatedState.metadataBytes], { type: "text/plain;charset=utf-8" }), "metadata.sque");
  });

  downloadZipButton.addEventListener("click", function () {
    if (!generatedState.zipBlob) {
      return;
    }
    downloadBlob(generatedState.zipBlob, "latest.metadata");
  });

  includeZipInput.addEventListener("change", function () {
    invalidateGeneratedState();
    clearMessages();
  });

  autoPackageSizeInput.addEventListener("change", function () {
    var file = packageFileInput.files && packageFileInput.files[0];
    invalidateGeneratedState();
    if (file && autoPackageSizeInput.checked) {
      packageSizeInput.value = formatFileSize(file.size);
    }
  });

  scriptSystemverSelect.addEventListener("change", function () {
    if (previewTimer) {
      clearTimeout(previewTimer);
      previewTimer = null;
    }
    refreshPreviewOnly();
  });

  openScriptButton.addEventListener("click", openScriptModal);
  closeScriptButton.addEventListener("click", closeScriptModal);
  insertTemplateButton.addEventListener("click", function () {
    setScriptValue(SCRIPT_TEMPLATE);
    invalidateGeneratedState();
    clearMessages();
    renderAutocomplete();
    focusScriptEditor();
  });

  scriptModal.addEventListener("click", function (event) {
    if (event.target === scriptModal) {
      closeScriptModal();
    }
  });

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape" && !scriptModal.hidden) {
      closeScriptModal();
    }
  });

  scriptChipButtons.forEach(function (button) {
    button.addEventListener("click", function () {
      insertTextAtCursor(button.getAttribute("data-insert") || "");
    });
  });

  if (scriptCodeMirror) {
    scriptCodeMirror.on("change", handleScriptEditorInput);
    scriptCodeMirror.on("cursorActivity", renderAutocomplete);
    scriptCodeMirror.on("focus", renderAutocomplete);
    scriptCodeMirror.on("blur", handleScriptEditorBlur);
    scriptCodeMirror.on("keydown", function (_instance, event) {
      handleScriptEditorKeydown(event);
    });
  } else {
    scriptEditor.addEventListener("input", handleScriptEditorInput);
    scriptEditor.addEventListener("click", renderAutocomplete);
    scriptEditor.addEventListener("keyup", renderAutocomplete);
    scriptEditor.addEventListener("blur", handleScriptEditorBlur);
    scriptEditor.addEventListener("keydown", handleScriptEditorKeydown);
  }

  tabButtons.forEach(function (button) {
    button.addEventListener("click", function () {
      tabButtons.forEach(function (item) {
        item.classList.remove("active");
      });
      Array.prototype.forEach.call(document.querySelectorAll(".preview-box"), function (preview) {
        preview.classList.remove("active");
      });
      button.classList.add("active");
      document.getElementById(button.getAttribute("data-target")).classList.add("active");
    });
  });

  form.addEventListener("input", function (event) {
    if (event.target && FORM_CHANGE_SKIP[event.target.id]) {
      return;
    }
    invalidateGeneratedState();
    clearMessages();
  });

  form.addEventListener("change", function (event) {
    if (event.target && FORM_CHANGE_SKIP[event.target.id]) {
      return;
    }
    invalidateGeneratedState();
    clearMessages();
  });

  zipStatus.textContent = includeZipInput.checked ? "待生成" : "未启用";
  refreshPreviewOnly();
})();
