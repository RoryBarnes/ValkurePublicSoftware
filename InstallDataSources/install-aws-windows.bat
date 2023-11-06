@echo off
setlocal

echo Installation of the AWS CLI package is performed via their installer. Please select all default options.
pause
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

echo.
echo WARNING: There is one final step you must complete manually to finish the AWS CLI installation! 
echo Please copy and paste the following command into this Powershell terminal: 

echo.
echo [Environment]::SetEnvironmentVariable("Path", $Env:PATH + ";C:\Program Files\Amazon\AWSCLIV2", [System.EnvironmentVariableTarget]::User)
echo.
echo WARNING: You will need to reboot in order to complete the AWS CLI installation.
echo.

endlocal