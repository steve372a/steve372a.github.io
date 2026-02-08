@echo off
cd /d %~dp0
SET /P LANGUAGE_DIR=< .\share\config\language.ini
type %LANGUAGE_DIR%\help.lang
echo.
cmd