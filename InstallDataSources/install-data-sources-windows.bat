@echo off
setlocal

:: Define the download URL for the Nmap installer
set "nmapUrl=https://nmap.org/dist/nmap-7.92-setup.exe"

:: Define the installation directory (you can change this if needed)
set "installDir=C:\Program Files\Nmap"

:: Download the Nmap installer
echo Downloading Nmap installer...
curl -o nmap-setup.exe %nmapUrl%

:: Install Nmap via the GUI
echo Installing Nmap. Please select aall default options, except you do not need to install icons.
start /wait nmap-setup.exey

:: Clean up the installer
del nmap-setup.exe

echo Nmap installation complete.

:: Optional: Add Nmap to the system PATH
setx PATH "%installDir%;%PATH%"

endlocal
