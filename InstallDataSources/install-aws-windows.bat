@echo off
setlocal

echo Installation of the AWS CLI package is performed via their installer. Please select all default options.
pause
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
echo AWS CLI installation complete.

endlocal