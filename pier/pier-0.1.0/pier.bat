@echo off
@rem 设置一些基础设置：
@rem !!多语言支持!!
title Pier by ？、アイドル宣言
cd /d %~dp0
SET version=0.1.0
SET /P LANGUAGE_DIR=<language.ini
SET /P error1=< %LANGUAGE_DIR%\error1.lang
SET /P error2=< %LANGUAGE_DIR%\error2.lang
SET /P error3=< %LANGUAGE_DIR%\error3.lang
SET /P error4=< %LANGUAGE_DIR%\error4.lang
SET /P error5=< %LANGUAGE_DIR%\error5.lang
SET /P welcome=< %LANGUAGE_DIR%\welcome.lang
SET /P updatingmetadata=< %LANGUAGE_DIR%\updatingmetadata.lang
SET /P list1=< %LANGUAGE_DIR%\list1.lang
SET /P list2=< %LANGUAGE_DIR%\list2.lang
SET /P list3=< %LANGUAGE_DIR%\list3.lang
SET /P choice1=< %LANGUAGE_DIR%\choice1.lang
SET /P choicelang=< %LANGUAGE_DIR%\choicelang.lang
SET /P startdownload=< %LANGUAGE_DIR%\startdownload.lang
SET /P installing=< %LANGUAGE_DIR%\installing.lang
SET /P langsetok=< %LANGUAGE_DIR%\langsetok.lang
SET /P Installcomplete=< %LANGUAGE_DIR%\Installcomplete.lang
SET /P existlanguage=< %LANGUAGE_DIR%\existlanguage.lang
SET /P Installcompletelanguage=< %LANGUAGE_DIR%\Installcompletelanguage.lang
SET /P source=<sourceimage.ini

echo %welcome% %version%
SET parameters=%1
SET package=%2
SET custom=%3
If "%parameters%"=="" goto error1
If "%parameters%"=="install" goto installpackages
If "%parameters%"=="remove" goto installpackages
If "%parameters%"=="--help" goto help
If "%parameters%"=="help" goto help
If "%parameters%"=="?" goto help
If "%parameters%"=="--setlang" goto language
If "%parameters%"=="-h" goto help

:language
if "%package%"=="" goto error2
if "%package%"=="set" goto langset
if "%package%"=="install" goto langinstall
goto error2

:langset
echo .\language\%custom%>language.ini
SET /P LANGUAGE_DIR=<language.ini
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
mkdir %~dp0language\%custom%
copy %installdir%\*.* %~dp0language\%custom%> nul
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

:error4
echo %error4%
goto quit

:error5
echo %error5%
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

:quit