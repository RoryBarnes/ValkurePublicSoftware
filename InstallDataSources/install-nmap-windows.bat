@echo off
setlocal

set "nmapUrl=https://nmap.org/dist/nmap-7.92-setup.exe"
set "installDir=C:\Program Files (x86)\Nmap"
curl -o nmap-setup.exe %nmapUrl%
echo NMAP installation is completed via their installer. Please select all default options, except you do not need to install icons.
echo If prompted, upgrade your Npcap application.
pause
start /wait nmap-setup.exe
del nmap-setup.exe

echo.
echo WARNING: There is one final step you must complete manually to finish the NMAP installation! 
echo Please copy and paste the following command into this Powershell terminal: 

echo.
echo [Environment]::SetEnvironmentVariable("Path", $Env:PATH + ";C:\Program Files (x86)\Nmap", [System.EnvironmentVariableTarget]::User)
echo.
echo WARNING: You will need to reboot in order to complete the NMAP installation.
echo.

endlocal