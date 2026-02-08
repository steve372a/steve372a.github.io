@echo off
@rem 设置一些基础设置：
@rem !!多语言支持!!
title Package Installer by ？、アイドル宣言
cd /d %~dp0
SET version=1.0.0
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
SET /P source=< .\share\config\sourceimage.ini
SET /P pulllist=< .\share\config\listimage.ini

echo %welcome% %version%
SET parameters=%1
SET package=%2
SET custom=%3
If "%parameters%"=="" goto error1
If "%parameters%"=="install" goto installpackages
If "%parameters%"=="remove" goto removepackages
If "%parameters%"=="--help" goto help
If "%parameters%"=="help" goto help
If "%parameters%"=="?" goto help
If "%parameters%"=="license" start .\share\config\onlinelicense.exe && goto quit
If "%parameters%"=="list" goto listpackage
If "%parameters%"=="--setlang" goto language
If "%parameters%"=="-h" goto help

:listpackage
if "%package%"=="" goto error2
if "%package%"=="online" goto onlinepulllist
if "%package%"=="piersourcecode" type pier.bat && goto quit
if "%package%"=="offline" goto offlinepulllist
goto quit

:onlinepulllist
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%pulllist%"
If not exist %Temp%\listpackageonline.zip goto pullfailed
.\bin\unzip.exe %Temp%\listpackageonline.zip -d %~dp0metadata > nul
Del /f /s /q %Temp%\listpackageonline.zip > nul
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

:langinstall
if exist %~dp0language\%custom% goto langdelete
:forceinstalllanguage
@rem 下载元数据包
if "%custom%"=="" goto error2
.\bin\choice.exe /t 1 /c q /cs /D q > nul
echo %updatingmetadata%
.\bin\choice.exe /t 1 /c q /cs /D q > nul
Del /f /s /q .\metadata\*.* > nul
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate "%source%/%custom%.zip"
If not exist %Temp%\%custom%.zip goto error3
.\bin\unzip.exe %Temp%\%custom%.zip -d %~dp0metadata > nul
Del /f /s /q %Temp%\%custom%.zip > nul
.\bin\choice.exe /t 1 /c q /cs /D q > nul
@rem 设置元数据包的变量
SET /P packageversion=< .\metadata\version.sque
SET /P packagename=< .\metadata\packagename.sque
SET /P ossystem=< .\metadata\os.sque
echo %list1% %packagename%
echo %list2% %packageversion%
echo %choicelang%
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" goto langnext
If /I "%INS%"=="N" goto quit

:langnext
.\bin\choice.exe /t 1 /c q /cs /D q > nul
echo %startdownload% %packagename%...
SET /P packageurl=< .\metadata\url.sque
SET /P installername=< .\metadata\installername.sque
SET installdir=C:\steve372-folders\sources\pier@%ossystem%\%custom%
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %packageurl%
rename %Temp%\%installername%.pie %installername%-temp.exe > nul
echo %installing% %packagename%...
%Temp%\%installername%-temp.exe
Del /f /s /q %Temp%\%installername%-temp.exe > nul
mkdir %~dp0share\language\%custom%
copy %installdir%\*.* %~dp0share\language\%custom%> nul
Del /f /s /q %installdir%\*.* > nul
echo %Installcompletelanguage%
goto quit

:help
type %LANGUAGE_DIR%\help.lang
goto quit

:error1
echo %error1%
goto quit

:error2
echo %error2%
goto quit

:error3
echo %error3%
goto quit

:pullfailed
echo %pullfailed%
goto quit

:error4
echo %error4%
goto quit

:error5
echo %error5%
goto quit

:ok1
echo %ok1%
goto quit

:installpackages
@rem 下载元数据包
if "%package%"=="" goto error2
.\bin\choice.exe /t 1 /c q /cs /D q > nul
echo %updatingmetadata%
.\bin\choice.exe /t 1 /c q /cs /D q > nul
Del /f /s /q .\metadata\*.* > nul
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %source%/%package%.zip
If not exist %Temp%\%package%.zip goto error3
.\bin\unzip.exe %Temp%\%package%.zip -d %~dp0metadata > nul
Del /f /s /q %Temp%\%package%.zip > nul
.\bin\choice.exe /t 1 /c q /cs /D q > nul
@rem 设置元数据包的变量
SET /P packageversion=< .\metadata\version.sque
SET /P packagename=< .\metadata\packagename.sque
SET /P ossystem=< .\metadata\os.sque
echo %list1% %packagename%
echo %list2% %packageversion%
echo %list3% Windows %ossystem%+
echo %choice1%
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" goto next
If /I "%INS%"=="N" goto quit
@rem 安装软件
:next
.\bin\choice.exe /t 1 /c q /cs /D q > nul
echo %startdownload% %packagename%...
SET /P packageurl=< .\metadata\url.sque
SET /P installername=< .\metadata\installername.sque
SET installdir=C:\steve372-folders\sources\pier@%ossystem%\%package%\
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %packageurl% --show-progress
rename %Temp%\%installername%.pie %installername%-temp.exe > nul
echo %installing% %packagename%...
%Temp%\%installername%-temp.exe
Del /f /s /q %Temp%\%installername%-temp.exe > nul
if not exist C:\steve372-folders\sources\pier@%ossystem%\%package% goto error4
echo %Installcomplete% %installdir%
goto quit

:removepackages
if "%package%"=="" goto error2
.\bin\choice.exe /t 1 /c q /cs /D q > nul
echo %updatingmetadata%
.\bin\choice.exe /t 1 /c q /cs /D q > nul
Del /f /s /q .\metadata\*.* > nul
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %source%/%package%.zip
If not exist %Temp%\%package%.zip goto error3
.\bin\unzip.exe %Temp%\%package%.zip -d %~dp0metadata > nul
Del /f /s /q %Temp%\%package%.zip > nul
.\bin\choice.exe /t 1 /c q /cs /D q > nul
@rem 设置元数据包的变量
SET /P packagename=< .\metadata\packagename.sque
SET /P ossystem=< .\metadata\os.sque
SET /P installername=< .\metadata\installername.sque
if not exist C:\steve372-folders\sources\pier@%ossystem%\%package%\%installername%.exe goto ok1
echo %choiceremove% %packagename%?
SET /P INS= (Y/N): 
If /I "%INS%"=="Y" goto uninstallnext
If /I "%INS%"=="N" goto quit

:uninstallnext
echo %removepackage%...
if exist C:\steve372-folders\sources\pier@%ossystem%\%package%\uninstall.exe goto uninstaller
rd /s /q C:\steve372-folders\sources\pier@%ossystem%\%package% > nul
echo OK!
goto quit

:uninstaller
C:\steve372-folders\sources\pier@%ossystem%\%package%\uninstall.exe
echo OK!
goto quit
:quit