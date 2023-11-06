@echo off
setlocal

echo Installing OSQuery
set "osqueryUrl=https://pkg.osquery.io/windows/osquery-5.10.2.msi"
set "installDir=C:\Program Files\osquery"
curl -L -o osquery-installer.msi %osqueryUrl%
echo OSQuery installation is completed via their installer. Please select all default options, except you do not need to install icons.
pause
msiexec /i osquery-installer.msi
del osquery-installer.msi

echo.
echo WARNING: There is one final step you must complete manually to finish the OSQuery installation! 
echo Please copy and paste the following command into this Powershell terminal: 

echo.
echo [Environment]::SetEnvironmentVariable("Path", $Env:PATH + ";C:\Program Files\osquery", [System.EnvironmentVariableTarget]::User)
echo.
echo WARNING: You will need to reboot in order to complete the Suricata installation.
echo.

endlocal