arg="$1"

error=0
if [[ $# -ge 2 ]]; then
    error=1
fi

if [[ $# -eq 1 && "$arg" != "all" ]]; then
    error=1
fi

if [[ $error = 1 ]]; then
  echo "Usage: $0 [all], where all is optional"
  exit 1;
fi

if [[ $# -eq 1 && "$arg" = "all" ]]; then
    all=1
else
    all=0
fi

ok=0
if [[ "$OSTYPE" = "linux-gnu"* ]]; then
  PLATFORM=linux-x64
elif [[ "$OSTYPE" = "darwin"* ]]; then
  PLATFORM=osx-x64
elif [[ "$OSTYPE" = "msys" ]]; then
  PLATFORM=win-x64
  ok=1
elif [[ "$OSTYPE" = "win32" ]]; then
  PLATFORM=win-x64
  ok=1
else
  echo "Unsupported platform!"
  exit 1;
fi

if [[ $ok = 0 ]]; then
    echo ERROR: Incorrect operating system for this script
    if [[ "$PLATFORM" = "linux-x64" ]]; then
        echo Use script install-data-sources-linux.sh
    elif [[ "$PLATFORM" = "macos-x64" ]]; then
        echo Use script install-data-sources-macos.sh
    fi
fi

IsAdmin=$(env | grep SESSIONNAME)
if [[ -z "$IsAdmin" ]]; then
    echo Running as administrator
else
    echo ERROR: This script must be run as administrator
    echo Restart your Git Bash terminal by right clicking on the icon
    echo Then right-click on \"Git Bash\" and select \"Run as Administrator\"
    exit 1
fi

echo
echo Installing Valkure Data Sources on $PLATFORM
echo

echo -n "Do you have Docker Desktop installed [y/n]: "
read DockerInstalled
ok=0
while [ $ok = 0 ]
do
    if [[ "$DockerInstalled" = "y" || "$DockerInstalled" = "yes" || "$DockerInstalled" = "Y" || "$DockerInstalled" = "YES" || "$DockerInstalled" = "Yes" ]]; then
        DockerInstalled="y"
        ok=1
    elif [[ "$DockerInstalled" = "n" || "$DockerInstalled" = "no" || "$DockerInstalled" = "N" || "$DockerInstalled" = "NO" || "$DockerInstalled" = "No" ]]; then
        DockerInstalled="n"
        ok=1
    fi
done

if [[ "$DockerInstalled" = "n" ]]; then
    ok=0
    while [ $ok = 0 ]
    do
        echo -n "Do you want to install Docker now [y/n]: "
        read INSTALL_DOCKER
        if [[ "$INSTALL_DOCKER" = "y" || "$INSTALL_DOCKER" = "yes" || "$INSTALL_DOCKER" = "Y" || "$INSTALL_DOCKER" = "YES" || "$INSTALL_DOCKER" = "Yes" ]]; then
            INSTALL_NMAP="y"
            ok=1
        elif [[ "$INSTALL_DOCKER" = "n" || "$INSTALL_DOCKER" = "no" || "$INSTALL_DOCKER" = "N" || "$INSTALL_DOCKER" = "NO" || "$INSTALL_DOCKER" = "No" ]]; then
            INSTALL_DOCKER="n"
            ok=1
        fi
    done

    if [[ "$INSTALL_DOCKER" = "y" ]]; then
        echo Downloading installer
        curl -fsSL https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe -o DockerDesktopInstaller.exe
        echo Please follow the prompts to install Docker, including running it
        ./DockerDesktopInstaller
    else
        echo Cannot continue with Docker. Exiting. Data sources not installed
        exit 1
    fi
fi

echo
if [[ $all = 1 ]]; then
    INSTALL_NMAP="y"
    INSTALL_AWS="y"
    INSTALL_KUBE="y"
    INSTALL_OPENVAS="y"
    INSTALL_OSQUERY="y"
else
    ok=0
    while [ $ok = 0 ]
    do
        echo -n "Install NMAP [y/n]: "
        read INSTALL_NMAP
        if [[ "$INSTALL_NMAP" = "y" || "$INSTALL_NMAP" = "yes" || "$INSTALL_NMAP" = "Y" || "$INSTALL_NMAP" = "YES" || "$INSTALL_NMAP" = "Yes" ]]; then
            INSTALL_NMAP="y"
            ok=1
        elif [[ "$INSTALL_NMAP" = "n" || "$INSTALL_NMAP" = "no" || "$INSTALL_NMAP" = "N" || "$INSTALL_NMAP" = "NO" || "$INSTALL_NMAP" = "No" ]]; then
            INSTALL_NMAP="n"
            ok=1
        fi
    done

    ok=0
    while [ $ok = 0 ]
    do
        echo -n "Install AWS CLI [y/n]: "
        read INSTALL_AWS
        if [[ "$INSTALL_AWS" = "y" || "$INSTALL_AWS" = "yes" || "$INSTALL_AWS" = "Y" || "$INSTALL_AWS" = "YES" || "$INSTALL_AWS" = "Yes" ]]; then
            INSTALL_AWS="y"
            ok=1
        elif [[ "$INSTALL_AWS" = "n" || "$INSTALL_AWS" = "no" || "$INSTALL_AWS" = "N" || "$INSTALL_AWS" = "NO" || "$INSTALL_AWS" = "No" ]]; then
            INSTALL_AWS="n"
            ok=1
        fi
    done

    ok=0
    while [ $ok = 0 ]
    do
        echo -n "Install Kubernetes CLI [y/n]: "
        read INSTALL_KUBE
        if [[ "$INSTALL_KUBE" = "y" || "$INSTALL_KUBE" = "yes" || "$INSTALL_KUBE" = "Y" || "$INSTALL_KUBE" = "YES" || "$INSTALL_KUBE" = "Yes" ]]; then
            INSTALL_KUBE="y"
            ok=1
        elif [[ "$INSTALL_KUBE" = "n" || "$INSTALL_KUBE" = "no" || "$INSTALL_KUBE" = "N" || "$INSTALL_KUBE" = "NO" || "$INSTALL_KUBE" = "No" ]]; then
            INSTALL_KUBE="n"
            ok=1
        fi
    done

    ok=0
    while [ $ok = 0 ]
    do
        echo -n "Install OSQuery [y/n]: "
        read INSTALL_OSQUERY
        if [[ "$INSTALL_OSQUERY" = "y" || "$INSTALL_OSQUERY" = "yes" || "$INSTALL_OSQUERY" = "Y" || "$INSTALL_OSQUERY" = "YES" || "$INSTALL_OSQUERY" = "Yes" ]]; then
            INSTALL_OSQUERY="y"
            ok=1
        elif [[ "$INSTALL_OSQUERY" = "n" || "$INSTALL_OSQUERY" = "no" || "$INSTALL_OSQUERY" = "N" || "$INSTALL_OSQUERY" = "NO" || "$INSTALL_OSQUERY" = "No" ]]; then
            INSTALL_OSQUERY="n"
            ok=1
        fi
    done

    ok=0
    while [ $ok = 0 ]
    do
        echo -n "Install OpenVAS (Requires 20 GB) [y/n]: "
        read INSTALL_OPENVAS
        if [[ "$INSTALL_OPENVAS" = "y" || "$INSTALL_OPENVAS" = "yes" || "$INSTALL_OPENVAS" = "Y" || "$INSTALL_OPENVAS" = "YES" || "$INSTALL_OPENVAS" = "Yes" ]]; then
            INSTALL_OPENVAS="y"
            ok=1
        elif [[ "$INSTALL_OPENVAS" = "n" || "$INSTALL_OPENVAS" = "no" || "$INSTALL_OPENVAS" = "N" || "$INSTALL_OPENVAS" = "NO" || "$INSTALL_OPENVAS" = "No" ]]; then
            INSTALL_OPENVAS="n"
            ok=1
        fi
    done

    ok=0
    while [ $ok = 0 ]
    do
        echo -n "Install Suricata [y/n]: "
        read INSTALL_SURICATA
        if [[ "$INSTALL_SURICATA" = "y" || "$INSTALL_SURICATA" = "yes" || "$INSTALL_SURICATA" = "Y" || "$INSTALL_OPENVAS" = "YES" || "$INSTALL_OPENVAS" = "Yes" ]]; then
            INSTALL_SURICATA="y"
            ok=1
        elif [[ "$INSTALL_SURICATA" = "n" || "$INSTALL_SURICATA" = "no" || "$INSTALL_SURICATA" = "N" || "$INSTALL_OPENVAS" = "NO" || "$INSTALL_OPENVAS" = "No" ]]; then
            INSTALL_SURICATA="n"
            ok=1
        fi
    done
fi

if [[ "$INSTALL_OPENVAS" = "y" ]]; then
    ok=0
    while [ $ok = 0 ]
    do
        echo -n "Enter full path to ValkureFetch directory [press enter if not using Valkure]: "
        read VALKUREDIR
        if [[ -e $VALKUREDIR/valkure || -z $VALKUREDIR ]]; then
            ok=1
        else
            echo ERROR: Invalid directory!
        fi
    done
fi

echo
if [[ "$INSTALL_NMAP" = "n" ]]; then
    echo Skipping NMAP
else
    echo Downloading NMAP
    curl -fsSL https://nmap.org/dist/nmap-7.94-setup.exe -o nmap-7.94-setup.exe
    echo Installation of NMAP must be completed through its installer. 
    echo Please follow the instructions in the installation window that appears.
    echo Choose the default components and installation location. 
    echo You do NOT need shortcuts, but you can create them if you like.
    ./nmap-7.94-setup
    # export "PATH=$PATH:/c/Program Files (x86)/Nmap"
    echo NMAP installation complete.
fi

echo
if [[ "$INSTALL_KUBE" = "n" ]]; then
    echo Skipping Kubernetes CLI
else
    echo Installing Kubernetes CLI
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    mv kubectl /usr/bin
    chmod u+x /usr/kubectl
fi

echo
if [[ "$INSTALL_AWS" = "n" ]]; then
    echo Skipping AWS CLI
else
    echo Downloading AWS CLI
    hwclock -s
    curl -fsSL https://awscli.amazonaws.com/AWSCLIV2.msi -o AWSCLIV2.msi
    echo Installation of AWS CLI must be completed through its installer. 
    echo We will now open a File Explorer window for this directory.
    echo Please double-click the file AWSCLIV2.msi and follow the instructions.
    echo Please choose the default installation location.
    echo -n Press enter when ready
    read wait
    explorer .
    echo Press enter after completing the AWS CLI installation
    read wait
fi

echo
if [[ "$INSTALL_OSQUERY" = "n" ]]; then
    echo Skipping OSQuery
else
    echo Downloading OSQuery
    curl -fsSL  https://pkg.osquery.io/windows/osquery-5.9.1.msi -o osquery-5.9.1.msi
    echo Installation of OSQuery must be completed through its installer. 
    echo We will now open a File Explorer window for this directory.
    echo Please double-click the file osquery-5.9.1.msi and follow the instructions
    echo -n Press enter when ready
    read wait
    explorer .
    echo Press enter after completing the OSQuery installation
    read wait
fi

echo
if [[ "$INSTALL_OPENVAS" = "n" ]]; then
    echo Skipping OpenVAS
else
    echo Installing OpenVAS
    sudo apt install xmlstarlet
    sudo $INSTALLER remove docker-compose
    DOCKERDIR=/usr/bin
    DOCKERDEST=$DOCKERDIR/docker-compose
    DOCKERVER=1.29.0
    sudo curl -L https://github.com/docker/compose/releases/download/${DOCKERVER}/docker-compose-$(uname -s)-$(uname -m) -o $DOCKERDEST
    sudo chmod 755 $DOCKERDEST

    curl -f -O https://greenbone.github.io/docs/latest/_static/setup-and-start-greenbone-community-edition.sh && chmod u+x setup-and-start-greenbone-community-edition.sh
    sudo ./setup-and-start-greenbone-community-edition.sh
    echo -n "Re-enter password for OpenVAS admin account: " 
    read OPENVASPASS
    #echo $OPENVASPASS
    curl -f -L https://greenbone.github.io/docs/latest/_static/docker-compose-22.4.yml -o docker-compose.yml
    sudo docker-compose -f ./docker-compose.yml -p greenbone-community-edition exec -u gvmd gvmd gvmd --user=admin --new-password=$OPENVASPASS
    sudo docker-compose -f ./docker-compose.yml -p greenbone-community-edition run -d --rm gvm-tools

    if [[ -v $VALKUREDIR ]]; then
        sed -i 's@/home/stephan/Greenbone@'"$PWD"'@' $VALKUREDIR/conf/fetch.onprem.json
    fi
fi

echo
if [[ "$INSTALL_SURICATA" = "n" ]]; then
    echo Skipping Suricata
else
    echo Downloading Suricata
    curl -fsSL  https://www.openinfosecfoundation.org/download/windows/Suricata-7.0.0-1-64bit.msi -o Suricata-7.0.0-1-64bit.msi
    echo Installation of Suricata must be completed through its installer. 
    echo We will now open a File Explorer window for this directory.
    echo Please double-click the file Suricata-7.0.0-1-64bit.msi and follow the instructions
    echo -n Press enter when ready
    read wait
    explorer .
    echo Press enter after completing the Suricata installation
    read wait
    #export PATH="$PATH:/c/Program Files/Suricata"
fi

if [[ "$INSTALL_NMAP" = "y" || "$INSTALL_SURICATA" = "y" ]]; then
    echo
    echo "          **** IMPORTANT ****"
    echo
    echo "To finish the installation process, copy, paste and execute the following command(s):"
    echo
    if [[ "$INSTALL_NMAP" = "y" ]]; then
        echo export \"PATH=\$PATH:/c/Program Files \(x86\)/Nmap\"
    fi
    if [[ "$INSTALL_SURICATA" = "y" ]]; then
        echo export \"PATH=\$PATH:/c/Program Files/Suricata\"
    fi
fi