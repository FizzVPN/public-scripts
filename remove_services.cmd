@echo off
setlocal EnableExtensions DisableDelayedExpansion

:: --- self-elevate ---
net session >nul 2>&1
if errorlevel 1 (
    color 6
    echo ============================================================
    echo  This script must be run as Administrator.
    echo.
    echo  A UAC prompt will appear.
    echo  Please ACCEPT it and WAIT until the script continues.
    echo.
    echo  If nothing happens after approval, or the script does not
    echo  restart with administrator rights, please contact the
    echo  person who provided this script.
    echo ============================================================
    echo.
    pause

    set "SCRIPT_FULL_PATH=%~f0"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath $env:SCRIPT_FULL_PATH -ArgumentList 'CONTINUE' -Verb RunAs"
    if errorlevel 1 (
        echo.
        echo [ERROR] Failed to start the elevated part of the script.
        echo Please contact the person who provided this script.
        pause
    )
    exit /b
)

if /I "%~1"=="CONTINUE" shift

setlocal EnableDelayedExpansion
color 2
echo ============================================================
echo  The following services will be stopped and removed:
echo    - goodbyedpi
echo    - winws1
echo    - zapret
echo    - windivert
echo    - windivert14
echo ============================================================
echo.
pause

call :RemoveService "goodbyedpi"
call :RemoveService "GoodbyeDPI"
call :RemoveService "winws1"
call :RemoveService "zapret"
call :RemoveService "windivert"
call :RemoveService "WinDivert"
call :RemoveService "windivert14"
call :RemoveService "WinDivert1.3"
call :RemoveService "WinDivert1.4"

echo.
echo ============================================================
echo  Script completed.
echo.
echo  A SYSTEM RESTART IS RECOMMENDED
echo  to ensure all changes are fully applied.
echo ============================================================
echo.
pause
exit /b 0

:RemoveService
set "SVC=%~1"
echo.
echo [INFO] Processing %SVC% ...

sc query "%SVC%" >nul 2>&1
if errorlevel 1060 (
    echo [SKIP] Service %SVC% not found.
    goto :eof
)

sc stop "%SVC%" >nul 2>&1

set /a WAIT=0
:wait_loop
sc query "%SVC%" | find /I "STOPPED" >nul 2>&1
if not errorlevel 1 goto delete_service

set /a WAIT+=1
if !WAIT! GEQ 10 goto delete_service
timeout /t 1 /nobreak >nul
goto wait_loop

:delete_service
sc delete "%SVC%" >nul 2>&1

sc query "%SVC%" >nul 2>&1
if errorlevel 1060 (
    echo [OK] %SVC% removed.
) else (
    echo [WARNING] %SVC% still exists. It may be removed after reboot.
)
goto :eof
