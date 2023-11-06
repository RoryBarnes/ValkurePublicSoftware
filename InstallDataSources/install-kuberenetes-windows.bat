@echo off
setlocal

echo Installing KubeCTL
set KUBECTL_VERSION=v1.28.3
curl -LO https://dl.k8s.io/release/%KUBECTL_VERSION%/bin/windows/amd64/kubectl.exe
mkdir \KubeCTL
mv .\kubectl.exe KubeCTL

echo.
echo WARNING: There is one final step you must complete manually to finish the Kubernettes installation! 
echo Please copy and paste the following command into this Powershell terminal: 

echo.
echo [Environment]::SetEnvironmentVariable("Path", $Env:PATH + ";$pwd\KubeCTL", [System.EnvironmentVariableTarget]::User)
echo.
echo WARNING: You will need to reboot in order to complete the Kubernetes installation.
echo.

endlocal