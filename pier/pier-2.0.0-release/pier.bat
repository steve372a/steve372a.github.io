@echo off
:: 修复
setlocal enabledelayedexpansion
SET /P LANGUAGE_DIR=< .\share\config\language.ini
:: 设置一些基础设置：
:: !!多语言支持!!
:: 以下是初始化设置和语言配置加载部分
title Package Installer by Sanakaprix
cd /d %~dp0
SET version=2.0.0 Release

:: 清理可能残留的临时文件（添加延时防止文件占用）
if exist "%Temp%\pier_choice.tmp" (
    echo wscript.sleep 200 >%Temp%\Wait.vbs
    start /wait %Temp%\Wait.vbs
    del /f /q "%Temp%\pier_choice.tmp" 2>nul
)
if exist "%Temp%\pier_env.tmp" (
    echo wscript.sleep 200 >%Temp%\Wait.vbs
    start /wait %Temp%\Wait.vbs
    del /f /q "%Temp%\pier_env.tmp" 2>nul
)

for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[welcome\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "welcome=%%a"
<nul set /p "=%welcome% %version%"
:: 设置拉取软件包源的缺省路径
SET sourceimage=/sources
SET onlinelist=/list/listonline.zip

:: 加载安全审计与保护相关的多语言变量
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[Invalid_file_variable\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "invalid_file=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[error_protected_lang\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "error_protected_lang=%%a"
:: 语言支持（使用关键词搜索模式，避免行号依赖）
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[autoyes\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "autoyes=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[choiceapp\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "choiceapp=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[choicelang\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "choicelang=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[choiceremove\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "choiceremove=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[db_download_tip\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "db_download_tip=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[db_download_error\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "db_download_error=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[error_no_param\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "error_no_param=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[error_no_package\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "error_no_package=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[error_package_not_exist\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "error_package_not_exist=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[error_install_failed\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "error_install_failed=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[error_protected_lang\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "error_protected_lang=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[search_not_found\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "search_not_found=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[language_installed\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "language_installed=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[package_installed\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "package_installed=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[language_installed_success\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "language_installed_success=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[install_progress\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "install_progress=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[language_set_success\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "language_set_success=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[list_package_name\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "list_package_name=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[list_version\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "list_version=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[list_os_requirement\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "list_os_requirement=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[list_description\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "list_description=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[package_not_installed\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "package_not_installed=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[lang_onlinelist\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "lang_onlinelist=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[will_create_shortcut\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "will_create_shortcut=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[shortcut_created\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "shortcut_created=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[shortcut_failed\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "shortcut_failed=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[pull_list_failed\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "pull_list_failed=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[uninstall_progress\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "uninstall_progress=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[search_results_title\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "search_results_title=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[source_url_label\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "source_url_label=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[download_progress\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "download_progress=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[uninstall_success\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "uninstall_success=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[loading_metadata\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "loading_metadata=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[checking_source\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "checking_source=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[repo_changed\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "repo_changed=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[source_invalid\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "source_invalid=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[repo_change_confirm\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "repo_change_confirm=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[repo_change_confirm_2\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "repo_change_confirm_2=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[repo_change_confirm_3\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "repo_change_confirm_3=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[source_name_label\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "source_name_label=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[source_owner_label\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "source_owner_label=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[source_admin_label\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "source_admin_label=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[list_offline_disabled\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "list_offline_disabled=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[source_select_prompt\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "source_select_prompt=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[source_select_options\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "source_select_options=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[error_invalid_cmd\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "error_invalid_cmd=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[db_download_msg\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "db_download_msg=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[db_list_intro\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "db_list_intro=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[db_list_count_msg\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "db_list_count_msg=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[db_list_suffix\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "db_list_suffix=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[db_list_filename\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "db_list_filename=%%a"

echo.
:: 默认软件包源网络地址
SET /P source=< .\share\config\sourceimage.ini
:: 合并
SET full_list_url=%source%%onlinelist%
SET pies=/pies
SET full_source_url=%source%%sourceimage%
SET full_pies_url=%source%%pies%

:: 解析命令行参数
SET parameters=%1
SET package=%2
SET custom=%3
SET autoyes=%4
:: autoyes=自动执行安装
:: 智能检测 -y 参数位置
if /I "%2%"=="-y" (
    set "autoyes=-y"
    set "package=%3"
    set "custom=%4"
)
if /I "%3%"=="-y" (
    set "autoyes=-y"
    set "custom=%4"
)
If "%parameters%"=="" goto error1
If "%parameters%"=="install" goto installpackages
If "%parameters%"=="remove" goto removepackages
If "%parameters%"=="--help" goto help
If "%parameters%"=="-help" goto help
If "%parameters%"=="help" goto help
If "%parameters%"=="?" goto help
If "%parameters%"=="-?" goto help
If "%parameters%"=="--?" goto help
If "%parameters%"=="license" start .\share\config\onlinelicense.exe && goto quit
If "%parameters%"=="list" goto listpackage
If "%parameters%"=="--setlang" goto language
If "%parameters%"=="-setlang" goto language
If "%parameters%"=="setlang" goto language
If "%parameters%"=="sl" goto language
If "%parameters%"=="-h" goto help
If "%parameters%"=="sources" goto repo
If "%parameters%"=="search" goto search

:listpackage
if "%package%"=="" goto onlinepulllist
echo %error_invalid_cmd%
goto quit

:onlinepulllist
:: 延时 280ms
if exist %Temp%\db.sque Del /f /s /q %Temp%\db.sque > nul
if exist %Temp%\dbm.sque Del /f /s /q %Temp%\dbm.sque > nul
echo wscript.sleep 320 >%Temp%\Wait.vbs
start /wait %Temp%\Wait.vbs  
echo %db_download_msg%%db_list_filename%
:: 下载 db.sque（包列表）
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%source%/db.sque"
If not exist %Temp%\db.sque goto error_dbsque
:: 下载 dbm.sque（包数量元数据）
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%source%/dbm.sque"
If not exist %Temp%\db.sque goto error_dbsque
:: 读取 db.sque 和 dbm.sque（db.sque 包含包列表，dbm.sque 仅包含包数量）
SET /P dbmsq=< %Temp%\dbm.sque
if exist %Temp%\dbm.sque Del /f /s /q %Temp%\dbm.sque > nul
:: 以下是服务器列出的软件包，共有 X 个包。（dbmsq 是包数量）
echo %db_list_intro%%db_list_count_msg% %dbmsq% %db_list_suffix%
echo.
type %Temp%\db.sque
if exist %Temp%\db.sque Del /f /s /q %Temp%\db.sque > nul
goto quit

:offlinepulllist
echo %list_offline_disabled%
goto quit

:language
if "%package%"=="" goto error2
if "%package%"=="set" goto langset
if "%package%"=="install" goto langinstall
if "%package%"=="reins" goto langdelete
goto error2

:langset
echo .\share\language\%custom%> .\share\config\language.ini
SET /P LANGUAGE_DIR=< .\share\config\language.ini
for /f "delims=" %%a in ('.\bin\sed.exe -n "34p" %LANGUAGE_DIR%\lang.ini') do @set "language_set_success=%%a"
echo %language_set_success%
goto quit

:langdelete
if /I "%custom%"=="zh-CN" goto error5
if /I "%custom%"=="en-US" goto error5
echo %language_installed%
rd /s /q %~dp0share\language\%custom% > nul
goto langinstall

:: 如果检测到 pier install 的包是语言
:ifpackislang
SET custom=%package%
goto ifpackislang_ins

:langinstall
if exist %~dp0share\language\%custom% goto langdelete
:forceinstalllanguage
:: 下载元数据包
if "%custom%"=="" goto error2
:: 延时 280ms
echo wscript.sleep 280 >%Temp%\Wait.vbs
start /wait %Temp%\Wait.vbs
echo %loading_metadata%
:ifpackislang_ins
Del /f /s /q .\metadata\*.* > nul
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%full_source_url%/%custom%.metadata"
If not exist %Temp%\%custom%.metadata goto error3
.\bin\unzip.exe %Temp%\%custom%.metadata -d %~dp0metadata > nul
Del /f /s /q %Temp%\%custom%.metadata > nul
:: 设置元数据包的变量
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[Version\]/{n;p}" .\metadata\metadata.sque') do @set "packageversion=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[PackageName\]/{n;p}" .\metadata\metadata.sque') do @set "packagename=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[InstallerName\]/{n;p}" .\metadata\metadata.sque') do @set "installername=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[OS\]/{n;p}" .\metadata\metadata.sque') do @set "ossystem=%%a"
echo %list_package_name% %packagename%
echo %list_version% %packageversion%
:: 自动安装（语言包复用 install 命令的 autoyes 参数）
if /I "%autoyes%"=="-y" goto langnext
if /I "%autoyes%"=="y" goto langnext
if /I "%autoyes%"=="yes" goto langnext
echo.
echo %choicelang%
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" goto langnext
If /I "%INS%"=="N" goto quit
goto quit

:langnext
if exist %Temp%\%installername%.pie Del /f /s /q %Temp%\%installername%.pie > nul
:: 安装新语言
echo %download_progress% %packagename%...
:: 读取语言元数据 - packageurl
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[URL\]/{n;p}" .\metadata\metadata.sque') do @set "packageurl=%%a"
:: 设置临时解压文件夹
SET installtemp=C:\steve372-folders\sources\pier@%ossystem%\%custom%
:: 下载语言包
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %source%%packageurl%
rename %Temp%\%installername%.pie %installername%-temp.exe > nul
echo %install_progress% %packagename%...
:: 执行语言安装包，标准的包会解压至临时解压文件夹
%Temp%\%installername%-temp.exe
:: 安装语言
Del /f /s /q %Temp%\%installername%-temp.exe > nul
if not exist %~dp0share\language\%custom% mkdir %~dp0share\language\%custom%
copy %installtemp%\*.* %~dp0share\language\%custom%> nul
Del /f /s /q %installtemp%\*.* > nul
echo %language_installed_success%
goto quit

:search
:: 搜索，查询包。
:: 延时 280ms
if exist %Temp%\db.sque Del /f /s /q %Temp%\db.sque > nul
echo wscript.sleep 320 >%Temp%\Wait.vbs
start /wait %Temp%\Wait.vbs  
echo %db_download_tip%
:: 下载 db.sque
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%source%/db.sque"
If not exist %Temp%\db.sque goto error_dbsque
:: 读取 db.sque 文件并搜索匹配项
set counter='0'
set "dbfile=%TEMP%\db.sque"
echo 正在搜索 "%package%"...
findstr /i /r /c:"^.*%package%.*$" "%dbfile%" > results.tmp
:: 展示优化后的结果
if %errorlevel% equ 0 (
    echo %search_results_title%
    type results.tmp
    del results.tmp
) else (
    echo %search_not_found%
    if exist results.tmp del results.tmp
)
goto quit


:help
:: 显示语言环境中存储的帮助选项
type %LANGUAGE_DIR%\help.lang
goto quit

:: 各种错误显示后，%%变量实现多语言支持，退出pier

:error1
:: 参数为空值
echo %error_no_param%
goto quit

:: 非法字符
:error_inprepo
echo %error_invalid_cmd%
goto quit

:error2
echo %error_no_package%
goto quit

:error3
echo %error_package_not_exist%
goto quit

:error_dbsque
echo %db_download_error%
goto quit

:pullfailed
:: 拉取失败
echo %pull_list_failed%
goto quit

:error4
:: 包下载失败
echo %error_install_failed%
goto quit

:error5
:: 基本语言不能卸载
echo %error_protected_lang%
goto quit

:ok1
:: "这个应用你还没有安装。"
echo %package_not_installed%
goto quit

:repo
::跳转
if "%package%"=="" goto repo_chg
if "%package%"=="list" goto repo_check
if "%package%"=="change" goto repo_chg
if "%package%"=="chg" goto repo_chg
echo %error_invalid_cmd%
goto quit

:repo_chg
if /I "%custom%"=="" goto repo_chg2
:: 换源
echo %checking_source%
if exist %Temp%\db.sque Del /f /s /q %Temp%\db.sque > nul
:: 如果%custom%参数结尾是/，就删除
if "!custom:~-1!" == "/" ( 
    set "custom=!custom:~0,-1!"
)
:: 如果%custom%参数结尾是空格，就删除
if "!custom:~-1!" == " " (
    set "custom=!custom:~0,-1!"
)
:: 检查用户输入的源是否可以访问
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%custom%/info.sque"
If not exist %Temp%\info.sque goto error_repo
:: 读取源 info 信息（源信息文件采用相同格式：[标签]\n值\n空行）
for /f "delims=" %%a in ('.\bin\sed.exe -n "2p" %Temp%\info.sque') do @set "info_namecn=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "4p" %Temp%\info.sque') do @set "info_nameen=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "6p" %Temp%\info.sque') do @set "info_category=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "8p" %Temp%\info.sque') do @set "info_owner=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "10p" %Temp%\info.sque') do @set "info_admin=%%a"
Del /f /s /q %Temp%\info.sque > nul
:: 检测是否为官方源或安全源。
if /I "%custom%"=="https://steve372a.github.io/pier/repo" (
for /f "delims=" %%a in ('.\bin\sed.exe -n "82p" %LANGUAGE_DIR%\lang.ini') do @set "official=%%a"
)
if /I "%custom%"=="https://mirrors.myxuebi.top/pier" (
for /f "delims=" %%a in ('.\bin\sed.exe -n "84p" %LANGUAGE_DIR%\lang.ini') do @set "official=%%a"
)

:: 如果语言是中文，那么显示中文，否则显示英语。
if /I "%LANGUAGE_DIR%"==".\share\language\zh-CN" (
echo %source_name_label% %info_namecn% %official%
) else (
echo %source_name_label% %info_nameen% %official%
)
echo %source_owner_label% %info_owner%
echo %source_admin_label% %info_admin%
:: 检测安全软件源
if /I "%custom%"=="https://steve372a.github.io/pier/repo" goto nextchangemirror
if /I "%custom%"=="https://mirrors.myxuebi.top/pier" goto nextchangemirror
:: 免责声明
echo.
echo %repo_change_confirm%
echo %repo_change_confirm_2%
echo %repo_change_confirm_3%
:: Y继续，N或其他键退出。
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" echo. && goto nextchangemirror
goto quit
:nextchangemirror
:: 存在就删
if exist .\share\config\sourceimage.ini Del /f /s /q .\share\config\sourceimage.ini > nul
echo %custom%> .\share\config\sourceimage.ini
echo.
echo %repo_changed%
echo %custom%
goto quit

:: 快速换源
:repo_chg2
echo %source_select_prompt%
echo %source_select_options%
SET /P INS= 请选择: 
:: 选择用户操作
If /I "%INS%"=="1" (
    set "custom=https://steve372a.github.io/pier/repo"
    goto changesource
)
If /I "%INS%"=="2" (
    set "custom=https://mirrors.myxuebi.top/pier"
    goto changesource
)
goto quit

:: =========================================================== 快速换源 ===========================================================
:changesource
:: 换源
echo %checking_source%
if exist %Temp%\db.sque Del /f /s /q %Temp%\db.sque > nul
if /I "%custom%"=="" goto repo_chg2
:: 如果%custom%参数结尾是/，就删除
if "!custom:~-1!" == "/" ( 
    set "custom=!custom:~0,-1!"
)
:: 如果%custom%参数结尾是空格，就删除
if "!custom:~-1!" == " " (
    set "custom=!custom:~0,-1!"
)
:: 检查用户输入的源是否可以访问
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%custom%/info.sque"
If not exist %Temp%\info.sque goto error_repo
:: 读取源 info 信息（源信息文件采用相同格式：[标签]\n值\n空行）
for /f "delims=" %%a in ('.\bin\sed.exe -n "2p" %Temp%\info.sque') do @set "info_namecn=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "4p" %Temp%\info.sque') do @set "info_nameen=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "6p" %Temp%\info.sque') do @set "info_category=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "8p" %Temp%\info.sque') do @set "info_owner=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "10p" %Temp%\info.sque') do @set "info_admin=%%a"
Del /f /s /q %Temp%\info.sque > nul
:: 检测是否为官方源或安全源。
if /I "%custom%"=="https://steve372a.github.io/pier/repo" (
for /f "delims=" %%a in ('.\bin\sed.exe -n "82p" %LANGUAGE_DIR%\lang.ini') do @set "official=%%a"
) else (
    for /f "delims=" %%a in ('.\bin\sed.exe -n "84p" %LANGUAGE_DIR%\lang.ini') do @set "official=%%a"
)
if /I "%custom%"=="https://mirrors.myxuebi.top/pier" (
for /f "delims=" %%a in ('.\bin\sed.exe -n "84p" %LANGUAGE_DIR%\lang.ini') do @set "official=%%a"
)

:: 如果语言是中文，那么显示中文，否则显示英语。
if /I "%LANGUAGE_DIR%"==".\share\language\zh-CN" (
echo %source_name_label% %info_namecn% %official%
) else (
echo %source_name_label% %info_nameen% %official%
)
echo %source_owner_label% %info_owner%
echo %source_admin_label% %info_admin%
:: 检测安全软件源
if /I "%custom%"=="https://steve372a.github.io/pier/repo" goto nextchangemirror
if /I "%custom%"=="https://mirrors.myxuebi.top/pier" goto nextchangemirror
:: 免责声明
echo.
echo %repo_change_confirm%
echo %repo_change_confirm_2%
echo %repo_change_confirm_3%
:: Y继续，N或其他键退出。
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" echo. && goto nextchangemirror
goto quit
:nextchangemirror
:: 存在就删
if exist .\share\config\sourceimage.ini Del /f /s /q .\share\config\sourceimage.ini > nul
echo %custom%> .\share\config\sourceimage.ini
echo.
echo %repo_changed%
echo %custom%
goto quit

:error_repo
:: 软件源不可用。
echo %source_invalid%
goto quit

:: 检查镜像源
:repo_check
echo.
echo %lang_onlinelist%: 
echo %full_list_url%
echo %source_url_label%: 
echo %full_source_url%
goto quit

:: 包安装
:installpackages
:: --- 第一阶段：元数据提取 ---
if "%package%"=="" goto error2
echo %loading_metadata%
if exist ".\metadata\*.*" (
    del /f /q ".\metadata\*.*" > nul
)
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %full_source_url%/%package%.metadata
if not exist "%Temp%\%package%.metadata" goto error3
.\bin\unzip.exe "%Temp%\%package%.metadata" -d "%~dp0metadata" > nul
del /f /q "%Temp%\%package%.metadata" > nul

:: 使用 sed 提取关键变量 (包含 autorun)
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[PackageName\]/{n;p}" .\metadata\metadata.sque') do @set "P_NAME=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[Version\]/{n;p}" .\metadata\metadata.sque') do @set "P_VER=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[OS\]/{n;p}" .\metadata\metadata.sque') do @set "P_OS=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[InstallDir\]/{n;p}" .\metadata\metadata.sque') do @set "P_INSTALLDIR=%%a"
:: 去除 InstallDir 中的前导反斜杠
if "%P_INSTALLDIR:~0,1%"=="\" set "P_INSTALLDIR=%P_INSTALLDIR:~1%"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[Autorun\]/{n;p}" .\metadata\metadata.sque') do @set "P_AUTORUN=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[DesktopShortcut\]/{n;p}" .\metadata\metadata.sque') do @set "P_LNK=%%a"
:: 去除 DesktopShortcut 中的前导反斜杠
if "%P_LNK:~0,1%"=="\" set "P_LNK=%P_LNK:~1%"
:: 根据语言提取简介
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[ProFile\]/{n;p}" .\metadata\metadata.sque') do @set "P_DESC=%%a"

:: --- 第二阶段：HTA 交互 ---
set "P_ACTION=install"
if /I "%autoyes%"=="-y" (
    set "INS=Y"
) else (
    if /I "%autoyes%"=="y" (
        set "INS=Y"
    ) else (
        if /I "%autoyes%"=="yes" (
            set "INS=Y"
        ) else (
            :: 启动 HTA 前清理临时反馈文件
            if exist "%Temp%\pier_choice.tmp" (
                echo wscript.sleep 200 >%Temp%\Wait.vbs
                start /wait %Temp%\Wait.vbs
                del /f /q "%Temp%\pier_choice.tmp" 2>nul
            )
            if exist "%Temp%\pier_env.tmp" (
                echo wscript.sleep 200 >%Temp%\Wait.vbs
                start /wait %Temp%\Wait.vbs
                del /f /q "%Temp%\pier_env.tmp" 2>nul
            )

            :: 写入环境变量到临时文件（兼容 XP）
            echo (
                echo P_PKGNAME=%P_NAME%
                echo P_VERSION=%P_VER%
                echo P_OS=Windows %P_OS%
                echo P_DESC=%P_DESC%
                echo P_SHORTCUT=%P_LNK%
                echo P_LAB_NAME=%list_package_name%
                echo P_LAB_VER=%list_version%
                echo P_LAB_OS=%list_os_requirement%
                echo P_LAB_DESC=%list_description%
                echo P_LAB_LNK=%will_create_shortcut%
                echo P_ACTION=install
            ) > "%Temp%\pier_env.tmp"

            :: 等待文件写入完成
            echo wscript.sleep 200 >%Temp%\Wait.vbs
            start /wait %Temp%\Wait.vbs

            :: 启动 HTA
            start /wait "" mshta "%~dp0share\module\install.hta"

            :: 等待 HTA 完成后再读取结果
            echo wscript.sleep 200 >%Temp%\Wait.vbs
            start /wait %Temp%\Wait.vbs

            if exist "%Temp%\pier_choice.tmp" (
                set /p INS=<"%Temp%\pier_choice.tmp"
                del /f /q "%Temp%\pier_choice.tmp" 2>nul
            ) else (
                set "INS=N"
            )

            :: 清理环境变量文件（如果还存在）
            if exist "%Temp%\pier_env.tmp" del /f /q "%Temp%\pier_env.tmp" 2>nul
        )
    )
)
if /I "%INS%"=="N" goto quit

:: 清理环境变量文件（如果还存在）
if exist "%Temp%\pier_env.tmp" (
    del /f /q "%Temp%\pier_env.tmp" 2>nul
)

:: --- 第三阶段：下载安装包 ---
echo %download_progress% %P_NAME%...

:: 读取下载 URL 和快捷方式
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[URL\]/{n;p}" .\metadata\metadata.sque') do @set "packageurl=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[DesktopShortcut\]/{n;p}" .\metadata\metadata.sque') do @set "shortcut=%%a"

:: 下载安装包
if exist "%Temp%\%package%.pie" (
    del /f /q "%Temp%\%package%.pie" > nul
)
.\bin\uma-get.exe -P "%Temp%" --no-check-certificate %full_pies_url%/%package%.pie -q --show-progress
echo wscript.sleep 200 >%Temp%\Wait.vbs
start /wait %Temp%\Wait.vbs

:: 检查下载是否成功
if not exist "%Temp%\%package%.pie" (
    echo %error_package_not_exist%
    goto quit
)

:: --- 第四阶段：执行安装与安全审计 ---
echo %install_progress% %P_NAME%...
if /I "%P_OS%"=="language" (
    :: 语言包逻辑：保护 zh-CN
    if /I "%package%"=="zh-CN" (echo %error_protected_lang% & goto quit)
    .\bin\unzip.exe -o "%Temp%\%package%.pie" -d ".\share\language\" > nul
    echo %language_installed_success%
) else (
    :: 普通 App 逻辑：解压到对应目录（使用 InstallDir）
    if not exist ".\app\%P_INSTALLDIR%\" mkdir ".\app\%P_INSTALLDIR%\"
    .\bin\unzip.exe -o "%Temp%\%package%.pie" -d ".\app\%P_INSTALLDIR%" > nul

    :: 安全审计：如果 autorun 包含危险指令则拦截并报错
    if not "%P_AUTORUN%"=="" (
        if /I not "%P_AUTORUN%"=="null" (
            findstr /i "format net\ user rd\ /s del\ /s C:\\" ".\app\%P_INSTALLDIR%\%P_AUTORUN%" | findstr /i /v "%~dp0app" >nul
            if %errorlevel% equ 0 (
                echo %invalid_file% : %P_AUTORUN%
                del /f /q ".\app\%P_INSTALLDIR%\%P_AUTORUN%"
            ) else (
                call ".\app\%P_INSTALLDIR%\%P_AUTORUN%"
            )
        )
    )

    :: 处理桌面快捷方式：将 .lnk 文件从 App 文件夹移动到桌面
    if not "%P_LNK%"=="" (
        if /I not "%P_LNK%"=="null" (
            if exist ".\app\%P_INSTALLDIR%\%P_LNK%" (
                :: 移动快捷方式到桌面
                move /y ".\app\%P_INSTALLDIR%\%P_LNK%" "%userprofile%\Desktop\" > nul
                :: 检查是否移动成功
                if exist "%userprofile%\Desktop\%P_LNK%" (
                    echo %shortcut_created%%P_LNK%
                )
            )
        )
    )

    echo %package_installed% .\app\%P_INSTALLDIR%\
)
goto quit

:next
:: --- [路径重构] ---
:: 动态设置安装目录到程序根目录下的 app 文件夹
set "installdir=%~dp0app\%packagename%\"

if exist "%Temp%\%installername%.pie" del /f /q "%Temp%\%installername%.pie" > nul
echo %download_progress% %packagename%...

:: 读取下载 URL 和快捷方式
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[URL\]/{n;p}" .\metadata\metadata.sque') do @set "packageurl=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[DesktopShortcut\]/{n;p}" .\metadata\metadata.sque') do @set "shortcut=%%a"

:: 下载安装包
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %source%%packageurl% --show-progress
echo %install_progress% %packagename%...

:: --- [安装逻辑分发] ---
if /I "%ossystem%"=="language" (
    :: 语言包安装：直接解压到 share\language
    if /I "%package%"=="zh-CN" (echo %error_protected_lang% & goto quit)
    .\bin\unzip.exe -o "%Temp%\%package%.pie" -d ".\share\language\" > nul
    echo %language_installed_success%
) else (
    :: 普通应用安装：解压到刚才定义的 installdir
    if not exist "%installdir%" mkdir "%installdir%"
    .\bin\unzip.exe -o "%Temp%\%package%.pie" -d "%installdir%" > nul
    
    :: --- [核心安全审计：处理 autorun] ---
    if not "%p_autorun%"=="" (
        :: 确保目标脚本确实存在
        if exist "%installdir%%p_autorun%" (
            :: 扫描危险指令：禁止 format, net user, 越权删除, 以及对 C:\ 的直接操作（排除当前 app 目录）
            findstr /i "format net\ user rd\ /s del\ /s C:\\" "%installdir%%p_autorun%" | findstr /i /v "%~dp0app" >nul
            if !errorlevel! equ 0 (
                :: 审计发现风险：从 lang.ini 读取报错信息
                for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[Invalid_file_variable\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "err_audit=%%a"
                echo !err_audit! : %p_autorun%
                :: 删除风险脚本以绝后患，但安装的文件保留
                del /f /q "%installdir%%p_autorun%"
            ) else (
                :: 审计通过：切换至安装目录并安全执行
                pushd "%installdir%"
                call "%p_autorun%"
                popd
            )
        )
    )

    :: 处理桌面快捷方式：将 .lnk 文件从 App 文件夹移动到桌面
    if not "%shortcut%"=="" (
        if /I not "%shortcut%"=="null" (
            if exist "%installdir%%shortcut%" (
                move /y "%installdir%%shortcut%" "%userprofile%\Desktop\"
                echo %shortcut_created%%shortcut%
            )
        )
    )

    echo %package_installed% %installdir%
)
goto quit

:removepackages
:: --- 第一阶段：元数据下载与提取 ---
if "%package%"=="" goto error2
echo %loading_metadata%
if exist ".\metadata\*.*" (
    del /f /q ".\metadata\*.*" > nul
)
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %full_source_url%/%package%.metadata
if not exist "%Temp%\%package%.metadata" goto error3
.\bin\unzip.exe "%Temp%\%package%.metadata" -d "%~dp0metadata" > nul
del /f /q "%Temp%\%package%.metadata" > nul

:: 使用 sed 提取关键变量（确保与安装逻辑变量名对齐）
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[Version\]/{n;p}" .\metadata\metadata.sque') do @set "packageversion=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[PackageName\]/{n;p}" .\metadata\metadata.sque') do @set "packagename=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[OS\]/{n;p}" .\metadata\metadata.sque') do @set "ossystem=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[InstallDir\]/{n;p}" .\metadata\metadata.sque') do @set "P_INSTALLDIR=%%a"
:: 去除 InstallDir 中的前导反斜杠
if "%P_INSTALLDIR:~0,1%"=="\" set "P_INSTALLDIR=%P_INSTALLDIR:~1%"
:: 根据语言提取简介
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[ProFile\]/{n;p}" .\metadata\metadata.sque') do @set "P_DESC=%%a"

:: --- 第二阶段：UI 确认逻辑 ---
set "P_ACTION=uninstall"
if /I "%autoyes%"=="-y" (
    set "INS=Y"
) else (
    if /I "%autoyes%"=="y" (
        set "INS=Y"
    ) else (
        if /I "%autoyes%"=="yes" (
            set "INS=Y"
        ) else (
            if exist "%Temp%\pier_choice.tmp" (
                echo wscript.sleep 200 >%Temp%\Wait.vbs
                start /wait %Temp%\Wait.vbs
                del /f /q "%Temp%\pier_choice.tmp" 2>nul
            )
            if exist "%Temp%\pier_env.tmp" (
                echo wscript.sleep 200 >%Temp%\Wait.vbs
                start /wait %Temp%\Wait.vbs
                del /f /q "%Temp%\pier_env.tmp" 2>nul
            )

            :: 写入环境变量到临时文件（兼容 XP）
            echo (
                echo P_PKGNAME=%packagename%
                echo P_VERSION=%packageversion%
                echo P_OS=Windows %ossystem%
                echo P_DESC=%P_DESC%
                echo P_SHORTCUT=
                echo P_LAB_NAME=%list_package_name%
                echo P_LAB_VER=%list_version%
                echo P_LAB_OS=%list_os_requirement%
                echo P_LAB_DESC=%list_description%
                echo P_LAB_LNK=
                echo P_ACTION=uninstall
            ) > "%Temp%\pier_env.tmp"

            :: 等待文件写入完成
            echo wscript.sleep 200 >%Temp%\Wait.vbs
            start /wait %Temp%\Wait.vbs

            :: 调用 HTA 模块
            start /wait "" mshta "%~dp0share\module\install.hta"

            :: 等待 HTA 完成后再读取结果
            echo wscript.sleep 200 >%Temp%\Wait.vbs
            start /wait %Temp%\Wait.vbs

            if exist "%Temp%\pier_choice.tmp" (
                set /p INS=<"%Temp%\pier_choice.tmp"
                del /f /q "%Temp%\pier_choice.tmp" 2>nul
            ) else (
                set "INS=N"
            )

            :: 清理环境变量文件（如果还存在）
            if exist "%Temp%\pier_env.tmp" del /f /q "%Temp%\pier_env.tmp" 2>nul
        )
    )
)
if /I "%INS%"=="N" goto quit

:: --- 第三阶段：执行卸载流程 ---
echo %uninstall_progress% %packagename%...

:: 分支 1：如果是语言包逻辑
if /I "%ossystem%"=="language" (
    :: 强制保护 zh-CN
    if /I "%package%"=="zh-CN" (
        for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[error_protected_lang\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "err_protect=%%a"
        echo !err_protect!
        goto quit
    )
    if exist ".\share\language\%package%\" rd /s /q ".\share\language\%package%\"
    goto :uninstall_end
)

:: 分支 2：如果是普通 App 逻辑
:: 动态定位当前的安装目录（使用 InstallDir）
set "target_dir=%~dp0app\%P_INSTALLDIR%\"

:: 优先运行卸载程序（如果存在）
if exist "%target_dir%uninstall.exe" (
    start /wait "" "%target_dir%uninstall.exe"
)

:: 无论卸载程序是否残留，强制清理文件夹
if exist "%target_dir%" (
    rd /s /q "%target_dir%"
)

:uninstall_end
for /f "delims=" %%a in ('.\bin\sed.exe -n "/\[uninstall_success\]/{n;p}" %LANGUAGE_DIR%\lang.ini') do @set "uninstall_ok=%%a"
echo !uninstall_ok!
goto quit

:quit
Del /f /s /q .\metadata\*.* > nul