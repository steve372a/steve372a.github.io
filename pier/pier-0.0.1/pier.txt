@echo off
@rem 设置一些基础设置：
@rem !!多语言支持!!
cd /d %~dp0
SET version=0.0.1
SET /P LANGUAGE_DIR=<language.ini
SET /P error1=< %LANGUAGE_DIR%\error1.lang
SET /P error2=< %LANGUAGE_DIR%\error2.lang
SET /P error3=< %LANGUAGE_DIR%\error3.lang
SET /P welcome=< %LANGUAGE_DIR%\welcome.lang
SET /P updatingmetadata=< %LANGUAGE_DIR%\updatingmetadata.lang
SET /P list1=< %LANGUAGE_DIR%\list1.lang
SET /P list2=< %LANGUAGE_DIR%\list2.lang
SET /P choice1=< %LANGUAGE_DIR%\choice1.lang
SET /P startdownload=< %LANGUAGE_DIR%\startdownload.lang
SET /P installing=< %LANGUAGE_DIR%\installing.lang
SET /P Installcomplete=< %LANGUAGE_DIR%\Installcomplete.lang
SET /P source=<sourceimage.ini

echo %welcome% %version%
SET parameters=%1
SET package=%2
If "%parameters%"=="" goto error1
If "%parameters%"=="install" goto installpackages

:error1
echo %error1%
pause
goto quit

:error2
echo %error2%
pause
goto quit

:error3
echo %error3%
pause
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
echo %list1% %packagename%
echo %list2% %packageversion%
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
SET /P installdir=< .\metadata\installdir.sque
.\bin\uma-get.exe -q -P "%Temp%" --no-check-certificate %packageurl%
Del /f /s /q %Temp%\%installername%-temp.exe > nul
rename %Temp%\%installername%.pie %installername%-temp.exe > nul
echo %installing% %packagename%...
%Temp%\%installername%-temp.exe
echo %Installcomplete% %installdir%

:quit