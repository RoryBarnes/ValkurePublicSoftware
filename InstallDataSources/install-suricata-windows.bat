@echo off
setlocal enabledelayedexpansion

set "suricataUrl=https://www.openinfosecfoundation.org/downloads/windows/Suricata-6.0.15-1-64bit.msi"
set "installDir=C:\Suricata"
curl -o suricata-installer.msi %suricataUrl%
echo Suricata installation is completed via their installer. Please select all default options, and note you need Npcap if not already installed.
pause
msiexec /i suricata-installer.msi /L*V log.txt INSTALLDIR=%installDir%
del suricata-installer.msi

echo.
echo WARNING: There is one final step you must complete manually to finish the Suricata installation! 
echo Please copy and paste the following command into this Powershell terminal: 

echo.
echo [Environment]::SetEnvironmentVariable("Path", $Env:PATH + ";C:\Suricata", [System.EnvironmentVariableTarget]::User)
echo.
echo WARNING: You will need to reboot in order to complete the Suricata installation.
echo.

endlocal
