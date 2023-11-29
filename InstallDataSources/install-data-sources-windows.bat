@echo off
setlocal EnableDelayedExpansion

if not "%2"=="" goto error    

if not "%1"=="" (
    echo %1
    if "%1"=="all" (
        set all=1
        echo Installing all data sources
    ) else (
        goto error
    )
)

if "%all%"=="1" (
    set "INSTALL_NMAP=y"
    set "INSTALL_AWS=y"
    set "INSTALL_KUBE=y"
    set "INSTALL_OPENVAS=y"
    set "INSTALL_OSQUERY=y"
) else (
    echo Choose data sources to install

    :NMAP
    set /p INSTALL_NMAP="Install NMAP [y/n]: "
    if not "!INSTALL_NMAP!"=="y" (
        if not "!INSTALL_NMAP!"=="n" (
            echo Invalid input.
            goto NMAP
        )
    )

    :AWS
    set /p INSTALL_AWS="Install AWS CLI [y/n]: "
    if not "!INSTALL_AWS!"=="y" (
        if not "!INSTALL_AWS!"=="n" (
            echo Invalid input.
            goto AWS
        )
    )

    :KUBE
    set /p INSTALL_KUBE="Install Kubernetes CLI [y/n]: "
    if not "!INSTALL_KUBE!"=="y" (
        if not "!INSTALL_KUBE!"=="n" (
            echo Invalid input.
            goto KUBE
        )
    )

    :OSQUERY
    set /p INSTALL_OSQUERY="Install OSQuery [y/n]: "
    if not "!INSTALL_OSQUERY!"=="y" (
         if not "!INSTALL_OSQUERY!"=="n" (
            echo Invalid input.
            goto OSQUERY
        )
    )

    @REM :OPENVAS
    @REM set /p INSTALL_OPENVAS="Install OpenVAS [y/n]: "
    @REM if not "!INSTALL_OPENVAS!"=="y" (
    @REM     if not "!INSTALL_OPENVAS!"=="n" (
    @REM         echo Invalid input.
    @REM         goto OPENVAS
    @REM     )
    @REM )

    :SURICATA
    set /p INSTALL_SURICATA="Install Suricata [y/n]: "
    if not "!INSTALL_SURICATA!"=="y" (
        if not "!INSTALL_SURICATA!"=="n" (
            echo Invalid input.
            goto SURICATA
        )
    )
)

echo.

if /i "%INSTALL_NMAP%"=="n" (
    echo Skipping NMAP.
) else (
    echo Installing NMAP.
    set nmapUrl="https://nmap.org/dist/nmap-7.92-setup.exe"
    set nmapDir="C:\Program Files (x86)\Nmap"
    curl -o nmap-setup.exe !nmapUrl!
    echo NMAP installation will be completed via their installer. Please select all default options, except you do not need to install icons.
    echo If prompted, upgrade your Npcap application.
    pause
    start /wait nmap-setup.exe
    del nmap-setup.exe
    echo NMAP installation complete.
)

echo.

if /i "%INSTALL_AWS%"=="n" (
    echo Skipping AWS.
) else (
    echo Installing AWS CLI.
    set awsUrl="https://awscli.amazonaws.com/AWSCLIV2.msi"
    set awsDir="C:\Program Files\Amazon\AWSCLIV2"
    echo AWS CLI installation will be completed via their installer. Please select all default options.
    pause
    msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi
    echo AWS CLI installation complete.
)

echo.

if /i "%INSTALL_KUBE%"=="n" (
    echo Skipping Kube.
) else (
    echo Installing KubeCTL.
    set KUBECTL_VERSION=v1.28.3
    set kubeDir="~\KubeCTL"
    curl -LO https://dl.k8s.io/release/!KUBECTL_VERSION!/bin/windows/amd64/kubectl.exe
    if not exist !kubeDir! (
        mkdir !kubeDir!
    )
    Move kubectl.exe !kubeDir!
    echo KubeCTL installed in !KubeDir!. 
)

echo.

if /i "%INSTALL_OSQUERY%"=="n" (
    echo Skipping OSQuery
) else (
    echo Installing OSQuery
    set osqueryUrl="https://pkg.osquery.io/windows/osquery-5.10.2.msi"
    set osqueryDir="C:\Program Files\osquery"
    curl -L -o osquery-installer.msi !osqueryUrl!
    echo OSQuery installation is completed via their installer. Please select all default options, except you do not need to install icons.
    pause
    msiexec /i osquery-installer.msi
    del osquery-installer.msi
    echo OSQuery installation complete.
)

echo.

if /i "%INSTALL_SURICATA%"=="n" (
    echo Skipping Suricata
) else (
    echo Installing Suricata
    set suricataUrl="https://www.openinfosecfoundation.org/downloads/windows/Suricata-6.0.15-1-64bit.msi"
    set suricataDir="C:\Suricata"
    curl -o suricata-installer.msi !suricataUrl!
    echo Suricata installation is completed via their installer. Please select all default options, and note you need Npcap if not already installed.
    pause
    msiexec /i suricata-installer.msi /L*V log.txt INSTALLDIR=!suricataDir!
    del suricata-installer.msi
    echo OSQuery installation complete.
)

echo.

@REM if /i "%INSTALL_OPENVAS%"=="n" (
@REM     echo Skipping OpenVAS
@REM ) else (
@REM     echo Please see OpenVAS documentation for Windows installation.
@REM     pause
@REM )

echo Installation(s) complete.
echo.

endlocal

exit /b 0

:Error
echo Usage: %0 [all], where "all" is optional
exit /b 1