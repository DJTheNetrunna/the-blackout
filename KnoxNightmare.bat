@echo off
setlocal
set "KNOX_SCRIPT=%~dp0scripts\windows\Knox-Nightmare.ps1"

if not exist "%KNOX_SCRIPT%" (
  echo [knox-nightmare] ERROR: Windows installer script was not found.
  pause
  exit /b 1
)

powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%KNOX_SCRIPT%" %*
set "KNOX_EXIT=%ERRORLEVEL%"

if "%~1"=="" (
  echo.
  pause
)

exit /b %KNOX_EXIT%
