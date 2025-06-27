@ECHO OFF
echo This script will stop and delete this services:
echo 	GoodbyeDPI
echo 	Zapret(win-bundle)
echo 	Zapret-discord-youtube
echo 	Discord-fix
echo    WinDivert & WinDiver14
echo.
echo This script should be run with administrator privileges.
echo Right click - run as administrator.
echo.
echo Press any key if you're running it as administrator.
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
