@echo off
setlocal EnableDelayedExpansion

net session >nul 2>&1
if %errorlevel% neq 0 (
	color 6
    echo [WARN] This script require admin privileges
	echo Press any key to relaunch as admin
	pause
    powershell -Command "Start-Process '%~f0' -Verb RunAs -ArgumentList 'CONTINUE'"
    exit /b
)

if "%~1"=="CONTINUE" (
    shift
    goto :CONTINUE
)

:CONTINUE
color 2

echo [INFO] This script will stop and delete this services:
echo 	GoodbyeDPI
echo 	Zapret(win-bundle)
echo 	Zapret-discord-youtube
echo 	Discord-fix
echo 	WinDivert WinDivert14
echo.
echo [INFO] Press any key to continue...
pause
net stop goodbyedpi
sc delete goodbyedpi
net stop winws1
sc delete winws1
net stop zapret
sc delete zapret
net stop windivert
sc delete windivert
net stop windivert14
sc delete windivert14
pause
