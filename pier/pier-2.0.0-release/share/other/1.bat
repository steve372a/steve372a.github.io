@echo off
title 生成 Metadata
setlocal enabledelayedexpansion
:index
set "output=metadata.sque"
set /p folder=输入目录：

del "%output%" 2>nul
(
  for /f "delims=" %%a in ('dir /b /a-d "%folder%\*"') do (
    set "name=%%~na"          & rem 获取无扩展名的主名
    set "name=!name:.=!"      & rem 移除主名中的点号（如 my.file → myfile）
    echo [!name!]
    type "%folder%\%%a"
    echo;
  )
) > "%output%"
echo 合并完成！结果文件：%output%
copy %output% %folder% || echo 复制出现问题.
echo wscript.sleep 200 >%Temp%\Wait.vbs
start /wait %Temp%\Wait.vbs 
if exist !folder!\!output! (
	if exist metadata.sque del metadata.sque || echo 删除metadata.sque文件遇到问题
)
if exist !folder!\output.txt (del !folder!\output.txt || echo 删除output.txt文件遇到问题)

goto index