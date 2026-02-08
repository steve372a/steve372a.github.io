@echo off
set "source=C:\Users\Steve372\Desktop\pier-latest\share\language\zh-CN\122"
set "target=C:\Users\Steve372\Desktop\pier-latest\share\language\zh-CN\122\output\"

if not exist "%target%" mkdir "%target%"

for /r "%source%" %%f in (*.metadata) do (
    copy "%%f" "%target%\%%~nxf" /y
)