(function (mod) {
  if (typeof exports === "object" && typeof module === "object") {
    mod(require("../../lib/codemirror"), require("../../addon/mode/simple"));
  } else if (typeof define === "function" && define.amd) {
    define(["../../lib/codemirror", "../../addon/mode/simple"], mod);
  } else {
    mod(CodeMirror);
  }
})(function (CodeMirror) {
  "use strict";

  if (!CodeMirror || typeof CodeMirror.defineSimpleMode !== "function") {
    return;
  }

  CodeMirror.defineSimpleMode("sque", {
    start: [
      { regex: /\b(?:if|then|else)\b/i, token: "keyword" },
      { regex: /\{(?:systemver|os|version|packagesize)\}/i, token: "variable-2" },
      { regex: /==|!=|=/, token: "operator" },
      { regex: /"(?:[^"\\]|\\.)*"?/, token: "string" },
      { regex: /[(),;]/, token: "bracket" }
    ],
    meta: {
      dontIndentStates: ["start"],
      lineComment: null
    }
  });
});
