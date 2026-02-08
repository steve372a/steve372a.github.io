@echo off
setlocal
cd /d %~dp0

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WindowStyle Hidden"
    exit
)

:: 检查必要的工具是否存在
if not exist ".\bin\7za.exe" (
    msg * "错误：找不到 .\bin\7za.exe"
    exit
)

:: 使用 start 命令启动 HTA
start "" mshta "%~dp0Builder.hta"
exit