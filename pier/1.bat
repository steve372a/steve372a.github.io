@echo off
setlocal enabledelayedexpansion

REM 设置变量
set "totalFiles=0"
set "unzippedFiles=0"
set "progressWidth=25"  REM 进度条宽度（不包括[]）
set "unzipCommand=unzip -q yourfile.zip -d destination_folder"

REM 获取文件总数
for /f "tokens=2 delims=:" %%a in ('unzip -l yourfile.zip') do (
    set /a totalFiles+=1
)

REM 执行解压命令
%unzipCommand%

REM 显示进度条
:progress
set /a "unzippedFiles+=1"
set /a "percent=!unzippedFiles! * 100 / %totalFiles%"

REM 计算填充的#数量
set /a "filled=percent * progressWidth / 100"
set "progressBar="
for /l %%i in (1,1,!filled!) do set "progressBar=!progressBar!#"
for /l %%i in (!filled!,1,%progressWidth%) do set "progressBar=!progressBar! "

REM 显示进度条（无换行）
set /p "= [!progressBar!] [!percent!%%]" <nul

REM 如果未完成则继续
if !percent! lss 100 (
    timeout /t 0.1 >nul
    REM 回退光标到行首
    set /p "= " <nul
    goto progress
) else (
    echo.
    echo 解压完成!
)
