@echo off
cd /d "%~dp0"
setlocal enabledelayedexpansion
if exist "systeminfo.txt" del systeminfo.txt 1>nul 2>nul
systeminfo | findstr /C:"OS Ãû³Æ" >systeminfo.txt
findstr /l "XP" "systeminfo.txt"
IF %ERRORLEVEL% == 0 (
set WinOS=XP
set wincompatiblemode=yes
title Warning! ADBTOOLS_%czawa_Version%.exe
pause
title µ±Ç°²Ù×÷ÏµÍ³ÎªWindows XP)
IF %ERRORLEVEL% == 1 cls

findstr /l "vista" "systeminfo.txt"
IF %ERRORLEVEL% == 0 (
set WinOS=vista
set wincompatiblemode=yes
title µ±Ç°²Ù×÷ÏµÍ³ÎªWindows vista)
IF %ERRORLEVEL% == 1 cls

findstr /l "7" "systeminfo.txt"
IF %ERRORLEVEL% == 0 (
set WinOS=7
set wincompatiblemode=yes
title µ±Ç°²Ù×÷ÏµÍ³ÎªWindows 7)
IF %ERRORLEVEL% == 1 cls

findstr /l "8" "systeminfo.txt"
IF %ERRORLEVEL% == 0 (
set WinOS=8
set wincompatiblemode=yes
title µ±Ç°²Ù×÷ÏµÍ³ÎªWindows 8)
IF %ERRORLEVEL% == 1 cls

findstr /l "8.1" "systeminfo.txt"
IF %ERRORLEVEL% == 0 (
set WinOS=8.1
set wincompatiblemode=no
title µ±Ç°²Ù×÷ÏµÍ³ÎªWindows 8.1)
IF %ERRORLEVEL% == 1 cls

findstr /l "10" "systeminfo.txt"
IF %ERRORLEVEL% == 0 (
set WinOS=10
set wincompatiblemode=no
title µ±Ç°²Ù×÷ÏµÍ³ÎªWindows 10)
IF %ERRORLEVEL% == 1 cls

findstr /l "11" "systeminfo.txt"
IF %ERRORLEVEL% == 0 (
set WinOS=11
set wincompatiblemode=no
title µ±Ç°²Ù×÷ÏµÍ³ÎªWindows 11)
IF %ERRORLEVEL% == 1 cls
cls

del systeminfo.txt 1>nul 2>nul
:: ³õÊ¼»¯±äÁ¿
set "cpu_name=Î´ÉèÖÃ"
set "gpu_name=Î´ÉèÖÃ"
set "disk_name=Î´Öª"
set color_yellow=[33;40m&rem »ÆÉ«
set color_green=[32;40m&rem ÂÌÉ«
set color_white=[0m&rem °×É«
set color_white_w=[32;0&rem ºÚµ×°×É«
set color_white2=[33;0m&rem °×É«ºÚµ×
set color_red=[31;40m&rem ºì
set color_blue=[34;40m&rem À¶É«
set color_blue_s=[36;40m&rem Ç³À¶É«
set color_purple=[35;40m&rem ×ÏÉ«
set color_red_light=[39;41m&rem ±³¾°ºì°×É«×ÖÌå
set "title=[33m"      & rem »ÆÉ«
set "option=[32m"     & rem ÂÌÉ«
set "arrow=[31m"      & rem ºìÉ«
set "frame=[36m"      & rem ÇàÉ«
set "reset=[0m"

:: ¹ÜÀíÔ±È¨ÏÞ¼ì²â
fltmc >nul 2>&1
if %errorlevel% equ 0 (
    goto start

) else (
    goto noadmin
)

:start
:: ×Ô¶¯¼ì²â²¢ÏÂÔØQRes.exe
if not exist "QRes.exe" (
    title ÏÂÔØÖÐ...
    echo Î´¼ì²âµ½QRes.exe£¬ÕýÔÚ×Ô¶¯ÏÂÔØ...
    powershell -Command "Invoke-WebRequest -Uri 'https://download.informer.com/win-1193060439-70c10fb8-677cc394-9b2bfcc30d567c8d33-b4ca01a01866cbfa4-1039108925-1193218001/qres.zip' -OutFile 'QRes.zip'"
    powershell -Command "Expand-Archive -Path 'QRes.zip' -DestinationPath '.' -Force"
    del /f /q QRes.zip
    del /f /q qres.htm
    echo QRes.exe ÏÂÔØÍê³É£¡
)

:: ×Ô¶¯±¸·ÝCPUºÍGPUÏà¹Ø×¢²á±í£¨Ö»ÔÚregÎÄ¼þ¼Ð²»´æÔÚÊ±Ö´ÐÐÒ»´Î£©
if not exist "reg" (
    mkdir reg
    reg export "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0" "reg\cpu_backup.reg" /y >nul 2>nul
    reg query "HKLM\SYSTEM\CurrentControlSet\Enum\ACPI" /s /f "Processor" 2>nul | findstr /i "HKEY_" >reg\cpu_acpi_keys.txt
    for /f "delims=" %%i in (reg\cpu_acpi_keys.txt) do (
        reg export "%%i" "reg\cpu_acpi_%%~ni.reg" /y >nul 2>nul
    )
    reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "DeviceDesc" 2>nul | findstr /i "HKEY_" >reg\gpu_pci_keys.txt
    for /f "delims=" %%i in (reg\gpu_pci_keys.txt) do (
        reg export "%%i" "reg\gpu_pci_%%~ni.reg" /y >nul 2>nul
    )
    reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI" /s /f "FriendlyName" 2>nul | findstr /i "HKEY_" >reg\disk_scsi_keys.txt
    for /f "delims=" %%i in (reg\disk_scsi_keys.txt) do (
        reg export "%%i" "reg\disk_scsi_%%~ni.reg" /y >nul 2>nul
    )
)
cls
title Ö÷²Ëµ¥
echo %frame%¨X¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨[%reset%
echo %frame%¨U%title%      Ö÷²Ëµ¥      %frame%¨U%reset%
echo %frame%¨d¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨g%reset%
echo %frame%¨U                               ¨U%reset%
echo %frame%¨U  %option% 1. ¹¦ÄÜÑ¡ÏîÒ»  %frame%       ¨U%reset%
echo %frame%¨U  %option% 2. ¹¦ÄÜÑ¡Ïî¶þ  %frame%       ¨U%reset%
echo %frame%¨U  %option% 3. ¹¦ÄÜÑ¡ÏîÈý  %frame%       ¨U%reset%
echo %frame%¨U  %option% 4. ¹¦ÄÜÑ¡ÏîËÄ  %frame%       ¨U%reset%
echo %frame%¨U  %option% 5. ¹¦ÄÜÑ¡ÏîÎå  %frame%       ¨U%reset%
echo %frame%¨U                               ¨U%reset%
echo %frame%¨d¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨g%reset%
echo %frame%¨U  %option% 0. ÍË³öÏµÍ³   %frame%¨U%reset%
echo %frame%¨^¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨a%reset%

set /p choice=ÇëÊäÈëÑ¡ÏîÊý×Ö²¢»Ø³µ£º
if "%choice%"=="1" (
    echo ÄãÑ¡ÔñÁË¹¦ÄÜÑ¡ÏîÒ»
    cls
    goto system
) else if "%choice%"=="2" (
    echo ÄãÑ¡ÔñÁË¹¦ÄÜÑ¡Ïî¶þ
    goto menu
) else if "%choice%"=="3" (
    echo ÄãÑ¡ÔñÁË¹¦ÄÜÑ¡ÏîÈý
    goto menu
) else if "%choice%"=="4" (
    echo ÄãÑ¡ÔñÁË¹¦ÄÜÑ¡ÏîËÄ
    goto menu
) else if "%choice%"=="5" (
    echo ÄãÑ¡ÔñÁË¹¦ÄÜÑ¡ÏîÎå
    goto menu
) else if "%choice%"=="0" (
    exit /b
)

:system
title ÏµÍ³ÅäÖÃÐÞ¸Ä
echo ================== ÏµÍ³ÅäÖÃÐÞ¸Ä ==================
echo %option%1: Ó²¼þÀà %color_white%
echo %option%2: ¸öÐÔ»¯ %color_white%
echo %option%3: ÍøÂçÀà %color_white%
echo %option%4: ÔÓÏîÀà %color_white%
echo =================================================
echo 0: ·µ»ØÉÏ¼¶²Ëµ¥
echo.
set /p choice=ÇëÊäÈëÑ¡ÏîÊý×Ö²¢»Ø³µ£º
if "%choice%"=="1" (
    cls
    goto hardware
) else if "%choice%"=="2" (
    goto personalize
) else if "%choice%"=="3" (
    goto network
) else if "%choice%"=="4" (
    goto misc
) else if "%choice%"=="0" (
    goto start
) else if "%choice%"=="cls" (
    cls
    goto system
)

:hardware

:: »ñÈ¡µ±Ç°µÄ CPU ºÍ GPU Ãû³Æ
for /f "tokens=2 delims==" %%i in ('wmic cpu get name /value 2^>nul') do set "cpu_name=%%i"
for /f "tokens=2 delims==" %%i in ('wmic path win32_videocontroller get name /value 2^>nul') do set "gpu_name=%%i"

:: »ñÈ¡µ±Ç°·Ö±æÂÊ£¨ÐèQRes.exeÍ¬Ä¿Â¼£©
for /f "tokens=1 delims=," %%a in ('QRes.exe /S 2^>nul') do (
    for /f "tokens=1,2 delims=x" %%b in ("%%a") do (
        set "cur_width=%%b"
        set "cur_height=%%c"
    )
)
if "%cur_width%"=="" set "cur_width=Î´Öª"
if "%cur_height%"=="" set "cur_height=Î´Öª"
set "cur_resolution=%cur_width%x%cur_height%"

for /f "skip=1 tokens=*" %%i in ('wmic diskdrive get model') do (
    if not "%%i"=="" set "disk_name=%%i" & goto :break_disk
)
:break_disk
title Ó²¼þÅäÖÃÐÞ¸Ä
echo.
echo ================== Ó²¼þÅäÖÃÐÞ¸Ä ==================
echo µ±Ç°ÉèÖÃ£º
echo   CPUÐÍºÅ£º%color_red%%cpu_name%%color_white%
echo   GPUÐÍºÅ£º%color_red%%gpu_name%%color_white%
echo   Ó²ÅÌÃû³Æ£º%color_red%!disk_name!%color_white%
echo   ÏÔÊ¾Æ÷·Ö±æÂÊ£º%color_red%%cur_resolution%%color_white%
echo   ²Ù×÷ÏµÍ³°æ±¾Îª: %color_red%Win%WinOS%%color_white%
echo --------------------------------------------------
echo ¡¾CPU¡¿
echo     1. ÐÞ¸ÄCPUÐÍºÅ
echo     2. »Ö¸´CPUÐÍºÅ
echo --------------------------------------------------
echo ¡¾GPU¡¿
echo     3. ÐÞ¸ÄGPUÐÍºÅ
echo     4. »Ö¸´GPUÐÍºÅ
echo --------------------------------------------------
echo ¡¾ÏÔÊ¾Æ÷¡¿
echo     5. ÐÞ¸ÄÏÔÊ¾Æ÷·Ö±æÂÊ
echo --------------------------------------------------
echo ¡¾Ó²ÅÌ¡¿
echo     6. ÐÞ¸ÄÓ²ÅÌÃû³Æ
echo     7. »Ö¸´Ó²ÅÌÃû³Æ
echo --------------------------------------------------
echo ¡¾×¢²á±í¡¿
echo     8. ±¸·ÝÏà¹Ø×¢²á±í
echo     9. ±¸·ÝËùÓÐ×¢²á±í
echo --------------------------------------------------
echo     0. ·µ»ØÉÏ¼¶²Ëµ¥
echo ==================================================
set /p choice=ÇëÊäÈëÑ¡ÏîÊý×Ö²¢»Ø³µ£º
if "%choice%"=="1" (
    echo.
    set /p cpu_name=ÇëÊäÈëCPUÃû³Æ:
    set "cpu_modified=0"
    for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\ACPI" /s /f "Processor" 2^>nul ^| findstr /i "HKEY_"') do (
        reg add "%%i" /v "FriendlyName" /t REG_SZ /d "!cpu_name!" /f >nul && set "cpu_modified=1"
    )
    reg add "HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0" /v "ProcessorNameString" /t REG_SZ /d "!cpu_name!" /f >nul
    if "!cpu_modified!"=="1" (
        echo CPUÃû³ÆÒÑÐÞ¸ÄÎª£º!cpu_name!
    ) else (
        echo %color_red%Î´ÕÒµ½¿ÉÐÞ¸ÄµÄCPU×¢²á±íÏî£¬»òÐÞ¸ÄÊ§°Ü£¡%color_white%
    )
    timeout /t 2 >nul
    cls
    goto hardware
) else if "%choice%"=="2" (
    echo.
    echo ÕýÔÚ»Ö¸´CPU×¢²á±í...
    for %%f in (%~dp0reg\cpu_acpi_*.reg) do (
        reg import "%%f" >nul
    )
    reg import "%~dp0reg\cpu_backup.reg" >nul
    echo CPU×¢²á±íÒÑ»Ö¸´£¡
    timeout /t 2 >nul
    cls
    goto hardware
) else if "%choice%"=="3" (
    echo.
    set /p gpu_name=ÇëÊäÈëGPUÃû³Æ:
    set "gpu_modified=0"
    for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "DeviceDesc" 2^>nul ^| findstr /i "HKEY_"') do (
        reg add "%%i" /v "DeviceDesc" /t REG_SZ /d "!gpu_name!" /f >nul && set "gpu_modified=1"
    )
    if "!gpu_modified!"=="1" (
        echo GPUÃû³ÆÒÑÐÞ¸ÄÎª£º!gpu_name!
    ) else (
        echo %color_red%Î´ÕÒµ½¿ÉÐÞ¸ÄµÄGPU×¢²á±íÏî£¬»òÐÞ¸ÄÊ§°Ü£¡%color_white%
    )
    timeout /t 2 >nul
    cls
    goto hardware
) else if "%choice%"=="4" (
    echo.
    echo ÕýÔÚ»Ö¸´GPU×¢²á±í...
    for %%f in ("%~dp0reg\gpu_pci_*.reg") do (
        reg import "%%f" >nul
    )
    for %%f in (%~dp0reg\disk_scsi_*.reg) do (
        reg import "%%f" >nul
    )
    echo GPU×¢²á±íÒÑ»Ö¸´£¡
    timeout /t 2 >nul
    cls
    goto hardware
) else if "%choice%"=="5" (
    echo.
    goto fbl
) else if "%choice%"=="6" (
    echo.
    set /p disk_name=ÇëÊäÈëÓ²ÅÌÃû³Æ:
    set "disk_modified=0"
    for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI" /s /f "FriendlyName" 2^>nul ^| findstr /i "HKEY_"') do (
        reg add "%%i" /v "FriendlyName" /t REG_SZ /d "!disk_name!" /f >nul && set "disk_modified=1"
    )
    if "!disk_modified!"=="1" (
        echo Ó²ÅÌÃû³ÆÒÑÐÞ¸ÄÎª£º!disk_name!
    ) else (
        echo %color_red%Î´ÕÒµ½¿ÉÐÞ¸ÄµÄÓ²ÅÌ×¢²á±íÏî£¬»òÐÞ¸ÄÊ§°Ü£¡%color_white%
    )
    timeout /t 2 >nul
    cls
    goto hardware
) else if "%choice%"=="7" (
    echo.
    echo ÕýÔÚ»Ö¸´Ó²ÅÌ×¢²á±í...
    for %%f in ("%~dp0reg\disk_scsi_*.reg") do (
        reg import "%%f" >nul
    )
    echo Ó²ÅÌ×¢²á±íÒÑ»Ö¸´£¡
    timeout /t 2 >nul
    cls
    goto hardware
) else if "%choice%"=="8" (
    echo.
    echo ÕýÔÚ±¸·ÝÏà¹Ø×¢²á±í...
    if not exist "reg" mkdir reg
    reg export "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0" "reg\cpu_backup.reg" /y >nul 2>nul
    reg query "HKLM\SYSTEM\CurrentControlSet\Enum\ACPI" /s /f "Processor" 2>nul | findstr /i "HKEY_" >reg\cpu_acpi_keys.txt
    for /f "delims=" %%i in (reg\cpu_acpi_keys.txt) do (
        reg export "%%i" "reg\cpu_acpi_%%~ni.reg" /y >nul 2>nul
    )
    reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "DeviceDesc" 2>nul | findstr /i "HKEY_" >reg\gpu_pci_keys.txt
    for /f "delims=" %%i in (reg\gpu_pci_keys.txt) do (
        reg export "%%i" "reg\gpu_pci_%%~ni.reg" /y >nul 2>nul
    )
    reg query "HKLM\SYSTEM\CurrentControlSet\Enum\SCSI" /s /f "FriendlyName" 2>nul | findstr /i "HKEY_" >reg\disk_scsi_keys.txt
    for /f "delims=" %%i in (reg\disk_scsi_keys.txt) do (
        reg export "%%i" "reg\disk_scsi_%%~ni.reg" /y >nul 2>nul
    )
    echo ±¸·ÝÍê³É£¡
    timeout /t 2 >nul
    cls
    goto hardware
) else if "%choice%"=="9" (
    echo.
    echo ÕýÔÚ±¸·ÝÏµÍ³ËùÓÐ×¢²á±íµ½ reg_all ÎÄ¼þ¼Ð...
    if not exist "reg_all" mkdir reg_all
    reg export "HKLM" "reg_all\HKLM.reg" /y >nul 2>nul
    reg export "HKU" "reg_all\HKU.reg" /y >nul 2>nul
    reg export "HKCU" "reg_all\HKCU.reg" /y >nul 2>nul
    reg export "HKCR" "reg_all\HKCR.reg" /y >nul 2>nul
    reg export "HKCC" "reg_all\HKCC.reg" /y >nul 2>nul
    echo ËùÓÐ×¢²á±íÒÑ±¸·Ýµ½ reg_all ÎÄ¼þ¼Ð£¡
    timeout /t 2 >nul
    cls
    goto hardware
) else if "%choice%"=="0" (
    cls
    goto system
) else (
    echo.
    echo %color_red%ÊäÈë´íÎó£¬ÇëÖØÐÂÊäÈë£¡%color_white%
    pause
    cls
    goto hardware
)
:fbl
    cls
    echo.
    title ·Ö±æÂÊÅäÖÃÐÞ¸Ä
    echo ================== ·Ö±æÂÊÅäÖÃÐÞ¸Ä ==================
    echo ÇëÑ¡Ôñ·Ö±æÂÊ£º
    echo %option%1. 800x600%color_white%
    echo %option%2. 1024x768%color_white%
    echo %option%3. 1280x720%color_white%
    echo %option%4. 1280x1024%color_white%
    echo %option%5. 1366x768%color_white%
    echo %option%6. 1440x900%color_white%
    echo %option%7. 1600x900%color_white%
    echo %option%8. 1920x1080%color_white%
    echo %option%9. 2560x1440%color_white%
    echo %option%10. 3840x2160 (4K)%color_white%
    echo =================================================
    echo 0. ·µ»ØÉÏ¼¶²Ëµ¥
    set /p res_choice=ÇëÊäÈëÑ¡ÏîÊý×Ö²¢»Ø³µ£º
    if "%res_choice%"=="0" (
        cls
        goto hardware
    )
    if "%res_choice%"=="1"  set "resw=800"   & set "resh=600"
    if "%res_choice%"=="2"  set "resw=1024"  & set "resh=768"
    if "%res_choice%"=="3"  set "resw=1280"  & set "resh=720"
    if "%res_choice%"=="4"  set "resw=1280"  & set "resh=1024"
    if "%res_choice%"=="5"  set "resw=1366"  & set "resh=768"
    if "%res_choice%"=="6"  set "resw=1440"  & set "resh=900"
    if "%res_choice%"=="7"  set "resw=1600"  & set "resh=900"
    if "%res_choice%"=="8"  set "resw=1920"  & set "resh=1080"
    if "%res_choice%"=="9"  set "resw=2560"  & set "resh=1440"
    if "%res_choice%"=="10" set "resw=3840"  & set "resh=2160"
    if defined resw (
        QRes.exe /x:!resw! /y:!resh!
        if errorlevel 1 (
            echo %color_red%·Ö±æÂÊÇÐ»»Ê§°Ü£¬ËùÑ¡Ä£Ê½²»±»Ö§³Ö£¡%color_white%
        ) else (
            echo ÏÔÊ¾Æ÷·Ö±æÂÊÒÑÐÞ¸ÄÎª£º!resw!x!resh!
        )
    ) else (
        echo Ñ¡ÔñÎÞÐ§£¬Î´ÐÞ¸Ä·Ö±æÂÊ¡£
    )
    timeout /t 2 >nul
    cls
    goto hardware

) else if "%choice%"=="0" (
    cls
    goto menu
)
echo.
echo ÊäÈë´íÎó£¬ÇëÖØÐÂÊäÈë£¡
pause
cls
goto hardware

:: ×Ô¶¯±¸·ÝCPUºÍGPUÏà¹Ø×¢²á±í
if not exist "reg" mkdir reg
reg export "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0" "reg\cpu_backup.reg" /y >nul
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\ACPI" /s /f "Processor" 2>nul | findstr /i "HKEY_" >reg\cpu_acpi_keys.txt
for /f "delims=" %%i in (reg\cpu_acpi_keys.txt) do (
    reg export "%%i" "reg\cpu_acpi_%%~ni.reg" /y >nul
)
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /s /f "DeviceDesc" 2>nul | findstr /i "HKEY_" >reg\gpu_pci_keys.txt
for /f "delims=" %%i in (reg\gpu_pci_keys.txt) do (
    reg export "%%i" "reg\gpu_pci_%%~ni.reg" /y >nul
)

:noadmin
cls
echo %color_red%¨X¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨[
echo %color_red%¨U                                            ¨U
echo %color_red%¨U  ¾¯¸æ£º±¾³ÌÐòÐèÒª¹ÜÀíÔ±È¨ÏÞ£¡              ¨U
echo %color_red%¨U                                            ¨U
echo %color_red%¨U  Çë°´ÒÔÏÂ²½Öè²Ù×÷£º                        ¨U
echo %color_red%¨U                                            ¨U
echo %color_red%¨U  1. ÓÒ¼üµã»÷±¾½Å±¾ÎÄ¼þ                     ¨U
echo %color_red%¨U  2. Ñ¡Ôñ¡¸ÒÔ¹ÜÀíÔ±Éí·ÝÔËÐÐ¡¹               ¨U
echo %color_red%¨U                                            ¨U
echo %color_red%¨^¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨a
echo %color_yellow%[ÖØÒªÌáÊ¾]%reset%
echo %color_red_light%²»ÓÃ¹ÜÀíÔ±È¨ÏÞÔËÐÐ¼¦¶ù¶¼¸øÄã´ò¶Ï%color_white%
echo °´ÈÎÒâ¼üÍË³öºóÖØÐÂÓÃ¹ÜÀíÔ±È¨ÏÞÔËÐÐ...
pause >nul
exit