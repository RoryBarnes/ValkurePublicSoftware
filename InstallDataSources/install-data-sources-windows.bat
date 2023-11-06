@echo off
setlocal enabledelayedexpansion

set "arg=%~1"
set "error=0"

if "%~2" neq "" set "error=1"

if "%arg%" neq "all" set "error=1"

if "%error%"=="1" (
    echo Usage: %0 [all], where "all" is optional
    goto Error
)

if "%arg%" == "all" (
    set all=1
) else (
    set all=0
)

echo !all!

if !all!==1 (
    set "INSTALL_NMAP=y"
    set "INSTALL_AWS=y"
    set "INSTALL_KUBE=y"
    set "INSTALL_OPENVAS=y"
    set "INSTALL_OSQUERY=y"
) else (
    :NMAP
    set /p INSTALL_NMAP=Install NMAP [y/n]: 
    echo You entered: %INSTALL_NMAP%
    @REM if "%INSTALL_NMAP%"=="y" (
    @REM     set "INSTALL_NMAP=y"
    @REM ) else if "%INSTALL_NMAP%"=="n" (
    @REM     set "INSTALL_NMAP=n"
    @REM ) else (
    @REM     echo Invalid input.
    @REM     goto NMAP
    @REM)

    set "ok=0"
    :AWS
    echo | set /p="Install AWS CLI [y/n]: "
    set /p INSTALL_AWS=
    if /i "!INSTALL_AWS!"=="y" (
        set "INSTALL_AWS=y"
        set "ok=1"
    ) else if /i "!INSTALL_AWS!"=="n" (
        set "INSTALL_AWS=n"
        set "ok=1"
    ) else (
        echo Invalid input.
        goto AWS
    )

    set "ok=0"
    :KUBE
    echo | set /p="Install Kubernetes CLI [y/n]: "
    set /p INSTALL_KUBE=
    if /i "!INSTALL_KUBE!"=="y" (
        set "INSTALL_KUBE=y"
        set "ok=1"
    ) else if /i "!INSTALL_KUBE!"=="n" (
        set "INSTALL_KUBE=n"
        set "ok=1"
    ) else (
        echo Invalid input.
        goto KUBE
    )

    set "ok=0"
    :OSQUERY
    echo | set /p="Install OSQuery [y/n]: "
    set /p INSTALL_OSQUERY=
    if /i "!INSTALL_OSQUERY!"=="y" (
        set "INSTALL_OSQUERY=y"
        set "ok=1"
    ) else if /i "!INSTALL_OSQUERY!"=="n" (
        set "INSTALL_OSQUERY=n"
        set "ok=1"
    ) else (
        echo Invalid input.
        goto OSQUERY
    )

    set "ok=0"
    :OPENVAS
    echo | set /p="Install OpenVAS (Requires 20 GB) [y/n]: "
    set /p INSTALL_OPENVAS=
    if /i "!INSTALL_OPENVAS!"=="y" (
        set "INSTALL_OPENVAS=y"
        set "ok=1"
    ) else if /i "!INSTALL_OPENVAS!"=="n" (
        set "INSTALL_OPENVAS=n"
        set "ok=1"
    ) else (
        echo Invalid input.
        goto OPENVAS
    )

    set "ok=0"
    :SURICATA
    echo | set /p="Install Suricata [y/n]: "
    set /p INSTALL_SURICATA=
    if /i "!INSTALL_SURICATA!"=="y" (
        set "INSTALL_SURICATA=y"
        set "ok=1"
    ) else if /i "!INSTALL_SURICATA!"=="n" (
        set "INSTALL_SURICATA=n"
        set "ok=1"
    ) else (
        echo Invalid input.
        goto SURICATA
    )
)

@REM echo Installation choices:
@REM echo INSTALL_NMAP: !INSTALL_NMAP!
@REM echo INSTALL_AWS: !INSTALL_AWS!
@REM echo INSTALL_KUBE: !INSTALL_KUBE!
@REM echo INSTALL_OSQUERY: !INSTALL_OSQUERY!
@REM echo INSTALL_OPENVAS: !INSTALL_OPENVAS!
@REM echo INSTALL_SURICATA: !INSTALL_SURICATA!

if /i "!INSTALL_NMAP!"=="n" (
    echo Skipping NMAP.
) else (
    echo Installing NMAP
    set "nmapUrl=https://nmap.org/dist/nmap-7.92-setup.exe"
    set "installDir=C:\Program Files\Nmap"
    curl -o nmap-setup.exe %nmapUrl%
    echo Installing Nmap. Please select aall default options, except you do not need to install icons.
    start /wait nmap-setup.exey
    del nmap-setup.exe
    setx PATH "%installDir%;%PATH%"
    echo NMAP installation complete.
)

if /i "!INSTALL_AWS!"=="n" (
    echo Skipping NMAP.
) else (
    echo Installing AWS CLI.
    curl -o awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"
    unzip awscliv2.zip
    .\aws\install
    echo AWS CLI installation complete.
)

if /i "!INSTALL_KUBE!"=="n" (
    echo Skipping Kube.
) else (
    set KUBECTL_VERSION=v1.22.2
    set INSTALL_DIR=C:\kubectl
    if not exist "!INSTALL_DIR!" (
        mkdir "!INSTALL_DIR!"
    )
    curl -LO https://dl.k8s.io/release/%KUBECTL_VERSION%/bin/windows/amd64/kubectl.exe
    move kubectl.exe "!INSTALL_DIR!"
    setx PATH "%PATH%;!INSTALL_DIR!"
    echo KubeCTL installed. You may need to restart your command prompt to use it.
)

if /i "!INSTALL_OSQUERY!"=="n" (
    echo Skipping OSQuery
) else (
    echo Installing OSQuery
    set "osqueryUrl=https://osquery.io/downloads/win32/osquery-5.1.0.1701.msi"
    set "installDir=C:\Program Files\osquery"
    curl -o osquery-installer.msi %osqueryUrl%
    msiexec /i osquery-installer.msi /qn
    del osquery-installer.msi
    setx PATH "%installDir%;%PATH%"
    echo OSQuery installation complete.
)
endlocal

:Error
exit /b 1