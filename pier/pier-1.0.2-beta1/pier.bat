@echo off
:: 设置一些基础设置：
:: !!多语言支持!!

:: 以下是初始化设置和语言配置加载部分
title Package Installer by Sanakaprix
cd /d %~dp0
SET version=1.0.2 Beta 1
:: 设置拉取软件包源的缺省路径
SET sourceimage=/sources
SET onlinelist=/list/listonline.zip
:: 语言支持
SET /P LANGUAGE_DIR=< .\share\config\language.ini
SET /P error1=< %LANGUAGE_DIR%\error1.lang
SET /P error2=< %LANGUAGE_DIR%\error2.lang
SET /P error3=< %LANGUAGE_DIR%\error3.lang
SET /P error4=< %LANGUAGE_DIR%\error4.lang
SET /P error5=< %LANGUAGE_DIR%\error5.lang
SET /P pullfailed=< %LANGUAGE_DIR%\pullfailed.lang
SET /P welcome=< %LANGUAGE_DIR%\welcome.lang
SET /P updatingmetadata=< %LANGUAGE_DIR%\updatingmetadata.lang
SET /P list1=< %LANGUAGE_DIR%\list1.lang
SET /P list2=< %LANGUAGE_DIR%\list2.lang
SET /P list3=< %LANGUAGE_DIR%\list3.lang
SET /P ok1=< %LANGUAGE_DIR%\ok1.lang
SET /P choice1=< %LANGUAGE_DIR%\choice1.lang
SET /P choicelang=< %LANGUAGE_DIR%\choicelang.lang
SET /P choiceremove=< %LANGUAGE_DIR%\choiceremove.lang
SET /P removepackage=< %LANGUAGE_DIR%\removepackage.lang
SET /P startdownload=< %LANGUAGE_DIR%\startdownload.lang
SET /P installing=< %LANGUAGE_DIR%\installing.lang
SET /P langsetok=< %LANGUAGE_DIR%\langsetok.lang
SET /P Installcomplete=< %LANGUAGE_DIR%\Installcomplete.lang
SET /P existlanguage=< %LANGUAGE_DIR%\existlanguage.lang
SET /P Installcompletelanguage=< %LANGUAGE_DIR%\Installcompletelanguage.lang
SET /P pack_create_shortcut=< %LANGUAGE_DIR%\packcreateshortcut.lang
SET /P autoyes=< %LANGUAGE_DIR%\autoyes.lang
SET /P lang_onlinelist=< %LANGUAGE_DIR%\onlinelist.lang
SET /P lang_sourceurl=< %LANGUAGE_DIR%\sourceurl.lang
SET /P uninsok=< %LANGUAGE_DIR%\uninsok.lang
:: 默认软件包源网络地址
SET /P source=< .\share\config\sourceimage.ini
:: 合并
SET full_list_url=%source%%onlinelist%
SET full_source_url=%source%%sourceimage%

:: 显示欢迎信息
echo %welcome% %version%

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
If "%parameters%"=="repo" goto repo_check

:listpackage
if "%package%"=="" goto error2
if "%package%"=="online" goto onlinepulllist
if "%package%"=="piersourcecode" type pier.bat && goto quit
if "%package%"=="offline" goto offlinepulllist
goto quit

:onlinepulllist
:: 1.0.2版本后，uma-get路径为%full_list_url%
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%full_list_url%"
If not exist %Temp%\listonline.zip goto pullfailed
.\bin\unzip.exe %Temp%\listonline.zip -d %~dp0metadata > nul
Del /f /s /q %Temp%\listonline.zip > nul
type %~dp0metadata\listpackageonline.pie
Del /f /s /q %~dp0metadata\listpackageonline.pie > nul
goto quit

:offlinepulllist
type %~dp0share\config\listpackageoffline.pie
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
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%full_source_url%/%custom%.zip"
If not exist %Temp%\%custom%.zip goto error3
.\bin\unzip.exe %Temp%\%custom%.zip -d %~dp0metadata > nul
Del /f /s /q %Temp%\%custom%.zip > nul
:: 设置元数据包的变量
SET /P packageversion=< .\metadata\version.sque
SET /P packagename=< .\metadata\packagename.sque
SET /P ossystem=< .\metadata\os.sque
echo %list1% %packagename%
echo %list2% %packageversion%
:: 自动安装
if /I "%autoyes%"=="-y" goto langnext
if /I "%autoyes%"=="y" goto langnext
if /I "%autoyes%"=="yes" goto langnext
echo %choicelang%
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" goto langnext
If /I "%INS%"=="N" goto quit
goto quit

:langnext
:: 安装新语言
echo %startdownload% %packagename%...
:: 读取语言元数据
SET /P packageurl=< .\metadata\url.sque
SET /P installername=< .\metadata\installername.sque
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

:help
:: 显示语言环境中存储的帮助选项
type %LANGUAGE_DIR%\help.lang
goto quit

:: 各种错误显示后，%%变量实现多语言支持，退出pier

:error1
:: 参数为空值
echo %error1%
goto quit

:error2
echo %error2%
goto quit

:error3
echo %error3%
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
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %full_source_url%/%package%.zip
If not exist %Temp%\%package%.zip goto error3
.\bin\unzip.exe %Temp%\%package%.zip -d %~dp0metadata > nul
Del /f /s /q %Temp%\%package%.zip > nul
:: 设置元数据包的变量
SET /P packageversion=< .\metadata\version.sque
SET /P packagename=< .\metadata\packagename.sque
SET /P ossystem=< .\metadata\os.sque
:: 如果检测到包是语言包，那么跳转至语言安装程序。
if /I "%ossystem%"=="language" goto ifpackislang
:: 显示包信息。
echo %list1% %packagename%
echo %list2% %packageversion%
echo %list3% Windows %ossystem%+
:: 检测 desktoplnk 快捷方式，如果没有就跳转
if not exist ".\metadata\desktoplnk.sque" goto nextinsp
echo %pack_create_shortcut%
goto nextinsp
:nextinsp
:: 自动安装
if /I "%custom%"=="-y" goto next
if /I "%custom%"=="y" goto next
if /I "%custom%"=="yes" goto next
:: 下一步
echo %choice1%
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" goto next
If /I "%INS%"=="N" goto quit
goto quit

:: 安装软件
:next
echo %startdownload% %packagename%...
SET /P packageurl=< .\metadata\url.sque
SET /P installername=< .\metadata\installername.sque
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
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %full_source_url%/%package%.zip
If not exist %Temp%\%package%.zip goto error3
.\bin\unzip.exe %Temp%\%package%.zip -d %~dp0metadata > nul
Del /f /s /q %Temp%\%package%.zip > nul
:: 设置元数据包的变量
SET /P packagename=< .\metadata\packagename.sque
SET /P ossystem=< .\metadata\os.sque
SET /P installername=< .\metadata\installername.sque
:: 检测 desktoplnk 快捷方式，如果有就跳转到 desklnk
if exist ".\metadata\desktoplnk.sque" (goto desklnk) else goto nextdelone
:desklnk
SET /P desktoplnk=< .\metadata\desktoplnk.sque
goto nextdelone
:nextdelone
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