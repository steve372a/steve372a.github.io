@echo off
:: 修复
setlocal enabledelayedexpansion
SET /P LANGUAGE_DIR=< .\share\config\language.ini
:: 设置一些基础设置：
:: !!多语言支持!!
:: 以下是初始化设置和语言配置加载部分
title Package Installer by Sanakaprix
cd /d %~dp0
SET version=2.0.0 Beta 1
for /f "delims=" %%a in ('.\bin\sed.exe -n "64p" %LANGUAGE_DIR%\lang.ini') do @set "welcome=%%a"
echo|set /p= %welcome% %version%
:: 设置拉取软件包源的缺省路径
SET sourceimage=/sources
SET onlinelist=/list/listonline.zip

:: 语言支持
for /f "delims=" %%a in ('.\bin\sed.exe -n "2p" %LANGUAGE_DIR%\lang.ini') do @set "autoyes=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "4p" %LANGUAGE_DIR%\lang.ini') do @set "choice1=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "6p" %LANGUAGE_DIR%\lang.ini') do @set "choicelang=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "8p" %LANGUAGE_DIR%\lang.ini') do @set "choiceremove=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "10p" %LANGUAGE_DIR%\lang.ini') do @set "download_db=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "12p" %LANGUAGE_DIR%\lang.ini') do @set "errdbs=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "14p" %LANGUAGE_DIR%\lang.ini') do @set "error1=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "16p" %LANGUAGE_DIR%\lang.ini') do @set "error2=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "18p" %LANGUAGE_DIR%\lang.ini') do @set "error3=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "20p" %LANGUAGE_DIR%\lang.ini') do @set "error4=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "22p" %LANGUAGE_DIR%\lang.ini') do @set "error5=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "24p" %LANGUAGE_DIR%\lang.ini') do @set "error_search=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "26p" %LANGUAGE_DIR%\lang.ini') do @set "existlanguage=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "28p" %LANGUAGE_DIR%\lang.ini') do @set "Installcomplete=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "30p" %LANGUAGE_DIR%\lang.ini') do @set "Installcompletelanguage=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "32p" %LANGUAGE_DIR%\lang.ini') do @set "installing=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "34p" %LANGUAGE_DIR%\lang.ini') do @set "langsetok=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "36p" %LANGUAGE_DIR%\lang.ini') do @set "list1=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "38p" %LANGUAGE_DIR%\lang.ini') do @set "list2=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "40p" %LANGUAGE_DIR%\lang.ini') do @set "list3=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "42p" %LANGUAGE_DIR%\lang.ini') do @set "list4=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "44p" %LANGUAGE_DIR%\lang.ini') do @set "ok1=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "46p" %LANGUAGE_DIR%\lang.ini') do @set "lang_onlinelist=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "48p" %LANGUAGE_DIR%\lang.ini') do @set "packcreateshortcut=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "50p" %LANGUAGE_DIR%\lang.ini') do @set "pullfailed=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "52p" %LANGUAGE_DIR%\lang.ini') do @set "removepackage=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "54p" %LANGUAGE_DIR%\lang.ini') do @set "results=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "56p" %LANGUAGE_DIR%\lang.ini') do @set "lang_sourceurl=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "58p" %LANGUAGE_DIR%\lang.ini') do @set "startdownload=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "60p" %LANGUAGE_DIR%\lang.ini') do @set "uninsok=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "62p" %LANGUAGE_DIR%\lang.ini') do @set "updatingmetadata=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "66p" %LANGUAGE_DIR%\lang.ini') do @set "check_sourcecnt=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "68p" %LANGUAGE_DIR%\lang.ini') do @set "lang_change_repo_1=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "70p" %LANGUAGE_DIR%\lang.ini') do @set "lang_error_repo=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "72p" %LANGUAGE_DIR%\lang.ini') do @set "lang_ifchange=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "73p" %LANGUAGE_DIR%\lang.ini') do @set "lang_ifchange2=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "74p" %LANGUAGE_DIR%\lang.ini') do @set "lang_ifchange3=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "76p" %LANGUAGE_DIR%\lang.ini') do @set "langinfo_name=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "78p" %LANGUAGE_DIR%\lang.ini') do @set "langinfo_owner=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "80p" %LANGUAGE_DIR%\lang.ini') do @set "langinfo_admin=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "86p" %LANGUAGE_DIR%\lang.ini') do @set "offline_error=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "88p" %LANGUAGE_DIR%\lang.ini') do @set "repo_change_1=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "92p" %LANGUAGE_DIR%\lang.ini') do @set "repo_change_2=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "94p" %LANGUAGE_DIR%\lang.ini') do @set "error6=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "96p" %LANGUAGE_DIR%\lang.ini') do @set "download_db2=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "98p" %LANGUAGE_DIR%\lang.ini') do @set "dbonline_1=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "100p" %LANGUAGE_DIR%\lang.ini') do @set "dbonline_2=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "102p" %LANGUAGE_DIR%\lang.ini') do @set "dbonline_3=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "104p" %LANGUAGE_DIR%\lang.ini') do @set "dbonline_4=%%a"

echo.
:: 默认软件包源网络地址
SET /P source=< .\share\config\sourceimage.ini
:: 合并
SET full_list_url=%source%%onlinelist%
SET full_source_url=%source%%sourceimage%

:: 解析命令行参数
SET parameters=%1
SET package=%2
SET custom=%3
:: autoyes=自动执行安装
SET autoyes=%4
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
echo %error6%
goto quit

:onlinepulllist
:: 延时 280ms
if exist %Temp%\db.sque Del /f /s /q %Temp%\db.sque > nul
if exist %Temp%\dbm.sque Del /f /s /q %Temp%\dbm.sque > nul
echo CreateObject("Scripting.FileSystemObject").DeleteFile(WScript.ScriptFullName) >%Temp%\Wait.vbs
echo wscript.sleep 320 >>%Temp%\Wait.vbs
start /wait %Temp%\Wait.vbs  
echo %download_db2%%dbonline_4%
:: 下载 db.sque
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%source%/db.sque"
If not exist %Temp%\db.sque goto error_dbsque
:: 下载 dbm.sque
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%source%/dbm.sque"
If not exist %Temp%\db.sque goto error_dbsque
:: 读取db.sque和dbm.sque
SET /P dbmsq=< %Temp%\dbm.sque
if exist %Temp%\dbm.sque Del /f /s /q %Temp%\dbm.sque > nul
:: 以下是服务器列出的软件包，共有 X 个包。
echo %dbonline_1%%dbonline_2% %dbmsq% %dbonline_3%
echo.
type %Temp%\db.sque
if exist %Temp%\db.sque Del /f /s /q %Temp%\db.sque > nul
goto quit

:offlinepulllist
echo %offline_error%
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
SET /P langsetok=< %LANGUAGE_DIR%\langsetok.lang
echo %langsetok%
goto quit

:langdelete
if /I "%custom%"=="zh-CN" goto error5
if /I "%custom%"=="en-US" goto error5
echo %existlanguage%
rd /s /q %~dp0language\%custom% > nul
goto langinstall

:: 如果检测到 pier install 的包是语言
:ifpackislang
SET custom=%package%
goto ifpackislang_ins

:langinstall
if exist %~dp0language\%custom% goto langdelete
:forceinstalllanguage
:: 下载元数据包
if "%custom%"=="" goto error2
:: 延时 280ms
echo CreateObject("Scripting.FileSystemObject").DeleteFile(WScript.ScriptFullName) >%Temp%\Wait.vbs
echo wscript.sleep 280 >>%Temp%\Wait.vbs
start /wait %Temp%\Wait.vbs
echo %updatingmetadata%
:ifpackislang_ins
Del /f /s /q .\metadata\*.* > nul
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%full_source_url%/%custom%.metadata"
If not exist %Temp%\%custom%.metadata goto error3
.\bin\unzip.exe %Temp%\%custom%.metadata -d %~dp0metadata > nul
Del /f /s /q %Temp%\%custom%.metadata > nul
:: 设置元数据包的变量
for /f "delims=" %%a in ('.\bin\sed.exe -n "16p" .\metadata\metadata.sque') do @set "packageversion=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "8p" .\metadata\metadata.sque') do @set "packagename=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "4p" .\metadata\metadata.sque') do @set "installername=%%a"
echo %list1% %packagename%
echo %list2% %packageversion%
:: 自动安装
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
echo %startdownload% %packagename%...
:: 读取语言元数据
for /f "delims=" %%a in ('.\bin\sed.exe -n "14p" .\metadata\metadata.sque') do @set "packageurl=%%a"
:: 设置临时解压文件夹
SET installtemp=C:\steve372-folders\sources\pier@%ossystem%\%custom%
:: 下载语言包
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %source%%packageurl%
rename %Temp%\%installername%.pie %installername%-temp.exe > nul
echo %installing% %packagename%...
:: 执行语言安装包，标准的包会解压至临时解压文件夹
%Temp%\%installername%-temp.exe
:: 安装语言
Del /f /s /q %Temp%\%installername%-temp.exe > nul
mkdir %~dp0share\language\%custom%
copy %installtemp%\*.* %~dp0share\language\%custom%> nul
Del /f /s /q %installtemp%\*.* > nul
echo %Installcompletelanguage%
goto quit

:search
:: 搜索，查询包。
:: 延时 280ms
if exist %Temp%\db.sque Del /f /s /q %Temp%\db.sque > nul
echo CreateObject("Scripting.FileSystemObject").DeleteFile(WScript.ScriptFullName) >%Temp%\Wait.vbs
echo wscript.sleep 320 >>%Temp%\Wait.vbs
start /wait %Temp%\Wait.vbs  
echo %download_db%
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
    echo %results%
    type results.tmp
    del results.tmp
) else (
    echo %error_search%
)
goto quit


:help
:: 显示语言环境中存储的帮助选项
type %LANGUAGE_DIR%\help.lang
goto quit

:: 各种错误显示后，%%变量实现多语言支持，退出pier

:error1
:: 参数为空值
echo %error1%
goto quit

:: 非法字符
:error_inprepo
echo %error_inprepo%
goto quit

:error2
echo %error2%
goto quit

:error3
echo %error3%
goto quit

:error_dbsque
echo %lang_errdbs%
goto quit

:pullfailed
:: 拉取失败
echo %pullfailed%
goto quit

:error4
:: 包下载失败
echo %error4%
goto quit

:error5
:: 基本语言不能卸载
echo %error5%
goto quit

:ok1
:: “这个应用你还没有安装。”
echo %ok1%
goto quit

:repo
::跳转
if "%package%"=="" goto repo_chg
if "%package%"=="list" goto repo_check
if "%package%"=="change" goto repo_chg
if "%package%"=="chg" goto repo_chg
echo %error6%
goto quit

:repo_chg
if /I "%custom%"=="" goto repo_chg2
:: 换源
echo %check_sourcecnt%
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
:: 读取源 info 信息
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
echo %langinfo_name% %info_namecn% %official%
) else (
echo %langinfo_name% %info_nameen% %official%
)
echo %langinfo_owner% %info_owner%
echo %langinfo_admin% %info_admin%
:: 检测安全软件源
if /I "%custom%"=="https://steve372a.github.io/pier/repo" goto nextchangemirror
if /I "%custom%"=="https://mirrors.myxuebi.top/pier" goto nextchangemirror
:: 免责声明
echo.
echo %lang_ifchange%
echo %lang_ifchange2%
echo %lang_ifchange3%
:: Y继续，N或其他键退出。
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" echo. && goto nextchangemirror
goto quit
:nextchangemirror
:: 存在就删
if exist .\share\config\sourceimage.ini Del /f /s /q .\share\config\sourceimage.ini > nul
echo %custom%> .\share\config\sourceimage.ini
echo.
echo %lang_change_repo_1%
echo %custom%
goto quit

:: 快速换源
:repo_chg2
echo %repo_change_1%
echo %repo_change_2%
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
echo %check_sourcecnt%
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
:: 读取源 info 信息
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
echo %langinfo_name% %info_namecn% %official%
) else (
echo %langinfo_name% %info_nameen% %official%
)
echo %langinfo_owner% %info_owner%
echo %langinfo_admin% %info_admin%
:: 检测安全软件源
if /I "%custom%"=="https://steve372a.github.io/pier/repo" goto nextchangemirror
if /I "%custom%"=="https://mirrors.myxuebi.top/pier" goto nextchangemirror
:: 免责声明
echo.
echo %lang_ifchange%
echo %lang_ifchange2%
echo %lang_ifchange3%
:: Y继续，N或其他键退出。
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" echo. && goto nextchangemirror
goto quit
:nextchangemirror
:: 存在就删
if exist .\share\config\sourceimage.ini Del /f /s /q .\share\config\sourceimage.ini > nul
echo %custom%> .\share\config\sourceimage.ini
echo.
echo %lang_change_repo_1%
echo %custom%
goto quit

:error_repo
:: 软件源不可用。
echo %lang_error_repo%
goto quit

:: 检查镜像源
:repo_check
echo.
echo %lang_onlinelist%: 
echo %full_list_url%
echo %lang_sourceurl%: 
echo %full_source_url%
goto quit

:: 包安装
:installpackages
:: 下载元数据包
if "%package%"=="" goto error2
:: 延时 280ms
echo CreateObject("Scripting.FileSystemObject").DeleteFile(WScript.ScriptFullName) >%Temp%\Wait.vbs
echo wscript.sleep 280 >>%Temp%\Wait.vbs
start /wait %Temp%\Wait.vbs
echo %updatingmetadata%
Del /f /s /q .\metadata\*.* > nul
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %full_source_url%/%package%.metadata
If not exist %Temp%\%package%.metadata goto error3
.\bin\unzip.exe %Temp%\%package%.metadata -d %~dp0metadata > nul
Del /f /s /q %Temp%\%package%.metadata > nul
:: 设置元数据包的变量
for /f "delims=" %%a in ('.\bin\sed.exe -n "16p" .\metadata\metadata.sque') do @set "packageversion=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "8p" .\metadata\metadata.sque') do @set "packagename=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "4p" .\metadata\metadata.sque') do @set "installername=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "6p" .\metadata\metadata.sque') do @set "ossystem=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "2p" .\metadata\metadata.sque') do @set "shortcut=%%a"
:: 如果检测到包是语言包，那么跳转至语言安装程序。
if /I "%ossystem%"=="language" goto ifpackislang
:: 显示包信息。
echo %list1% %packagename%
echo %list2% %packageversion%
echo %list3% Windows %ossystem%+
:: 检测 desktoplnk 快捷方式，如果没有就跳转
if /I "%shortcut%"=="null" goto nextinsp
echo %packcreateshortcut%
goto nextinsp
:nextinsp
:: 自动安装
if /I "%custom%"=="-y" goto next
if /I "%custom%"=="y" goto next
if /I "%custom%"=="yes" goto next
:: 下一步
echo.
echo %choice1%
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" goto next
If /I "%INS%"=="N" goto quit
goto quit

:: 安装软件
:next
if exist %Temp%\%installername%.pie Del /f /s /q %Temp%\%installername%.pie > nul
echo %startdownload% %packagename%...
for /f "delims=" %%a in ('.\bin\sed.exe -n "14p" .\metadata\metadata.sque') do @set "packageurl=%%a"
SET installdir=C:\steve372-folders\sources\pier@%ossystem%\%package%\
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %source%%packageurl% --show-progress
rename %Temp%\%installername%.pie %installername%-temp.exe > nul
echo %installing% %packagename%...
%Temp%\%installername%-temp.exe
Del /f /s /q %Temp%\%installername%-temp.exe > nul
if not exist C:\steve372-folders\sources\pier@%ossystem%\%package% goto error4
echo %Installcomplete% %installdir%
goto quit

:removepackages
if "%package%"=="" goto error2
:: 延时 280ms
echo CreateObject("Scripting.FileSystemObject").DeleteFile(WScript.ScriptFullName) >%Temp%\Wait.vbs
echo wscript.sleep 280 >>%Temp%\Wait.vbs
start /wait %Temp%\Wait.vbs
echo %updatingmetadata%
Del /f /s /q .\metadata\*.* > nul
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %full_source_url%/%package%.metadata
If not exist %Temp%\%package%.metadata goto error3
.\bin\unzip.exe %Temp%\%package%.metadata -d %~dp0metadata > nul
Del /f /s /q %Temp%\%package%.metadata > nul
:: 设置元数据包的变量
for /f "delims=" %%a in ('.\bin\sed.exe -n "16p" .\metadata\metadata.sque') do @set "packageversion=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "8p" .\metadata\metadata.sque') do @set "packagename=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "4p" .\metadata\metadata.sque') do @set "installername=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "6p" .\metadata\metadata.sque') do @set "ossystem=%%a"
for /f "delims=" %%a in ('.\bin\sed.exe -n "2p" .\metadata\metadata.sque') do @set "shortcut=%%a"
if not exist "C:\steve372-folders\sources\pier@%ossystem%\%package%\" goto ok1
:: 自动卸载
if /I "%custom%"=="-y" goto uninstallnext
if /I "%custom%"=="y" goto uninstallnext
if /I "%custom%"=="yes" goto uninstallnext
echo %choiceremove% %packagename%?
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" goto uninstallnext
If /I "%INS%"=="N" goto quit
goto quit

:uninstallnext
echo %removepackage%...
:: 寻找卸载程序
if exist C:\steve372-folders\sources\pier@%ossystem%\%package%\uninstall.exe goto uninstaller
:: 没有卸载程序就直接删文件夹
rd /s /q C:\steve372-folders\sources\pier@%ossystem%\%package% > nul
if exist .\metadata\desktoplnk.sque Del /f /s /q %userprofile%%desktoplnk% > nul
echo %packagename% %uninsok%
goto quit

:uninstaller
C:\steve372-folders\sources\pier@%ossystem%\%package%\uninstall.exe
if exist .\metadata\desktoplnk.sque Del /f /s /q %desktoplnk% > nul
echo %packagename% %uninsok%
goto quit

:quit
Del /f /s /q .\metadata\*.* > nul