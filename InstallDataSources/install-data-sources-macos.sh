arg="$1"

error=0
if [[ $# -ge 2 ]]; then
    error=1
fi

if [[ $# -eq 1 && "$arg" != "all" ]]; then
    error=1
fi

if [[ $# -eq 1 && "$arg" = "all" ]]; then
    all=1
else
    all=0
fi

if [[ $error = 1 ]]; then
    echo "Usage: $0 [all], where all is optional"
    exit 1
fi

ok=0
if [[ "$OSTYPE" = "linux-gnu"* ]]; then
  PLATFORM=linux-x64
elif [[ "${OSTYPE:0:6}" = "darwin" ]]; then
  ok=1
  PLATFORM=osx-x64
elif [[ "$OSTYPE" = "msys" ]]; then
  PLATFORM=win-x64
elif [[ "$OSTYPE" = "win32" ]]; then
  PLATFORM=win-x64
else
  echo "Unsupported platform!"
  exit 1;
fi

if [[ $ok = 0 ]]; then
    echo ERROR: Incorrect operating system for this script
    if [[ "$PLATFORM" = "linux-x64" ]]; then
        echo Use install-data-sources-macos.sh
    elif [[ "$PLATFORM" = "win-x64" ]]; then
        echo Use install-data-sources-windows.bat scripts in a Powershell
    fi
    exit 1
fi

echo
echo Installing Valkure Data Sources on $PLATFORM
echo

if command -v brew &>/dev/null; then
    installer="brew"
elif command -v port &>/dev/null; then
    installer="port"
else
    Neither brew nor macports is installed. Please install and try again.
fi

echo
echo Installing required dependencies
echo

if command -v curl &>/dev/null; then
    echo curl installed
else
    $installer install curl
fi

if command -v docker &>/dev/null; then
    echo docker installed
    dockerstatus=1
else
    dockerstatus=0
fi

if [[ $dockerstatus = 0 ]]; then
    echo "ERROR: Docker must be running to install data sources"
    ok=0
    while [ $ok = 0 ]; do
        read -p "Do you want to install Docker now [y/n]: " INSTALL_DOCKER
        if [[ "$INSTALL_DOCKER" = "y" || "$INSTALL_DOCKER" = "yes" || "$INSTALL_DOCKER" = "Y" || "$INSTALL_DOCKER" = "YES" || "$INSTALL_DOCKER" = "Yes" ]]; then
            ok=1
            INSTALL_DOCKER="y"
        elif [[ "$INSTALL_DOCKER" = "n" || "$INSTALL_DOCKER" = "no" || "$INSTALL_DOCKER" = "N" || "$INSTALL_DOCKER" = "NO" || "$INSTALL_DOCKER" = "No" ]]; then
            INSTALL_DOCKER="n"
            ok=1
        fi
    done

    if [[ "$INSTALL_DOCKER" = "y" ]]; then
        # Install Docker for macOS
        open -a Docker
    else
        echo "Data sources not installed"
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
    while [ $ok = 0 ]; do
        read -p "Install NMAP [y/n]: " INSTALL_NMAP
        if [[ "$INSTALL_NMAP" = "y" || "$INSTALL_NMAP" = "yes" || "$INSTALL_NMAP" = "Y" || "$INSTALL_NMAP" = "YES" || "$INSTALL_NMAP" = "Yes" ]]; then
            INSTALL_NMAP="y"
            ok=1
        elif [[ "$INSTALL_NMAP" = "n" || "$INSTALL_NMAP" = "no" || "$INSTALL_NMAP" = "N" || "$INSTALL_NMAP" = "NO" || "$INSTALL_NMAP" = "No" ]]; then
            INSTALL_NMAP="n"
            ok=1
        fi
    done

    ok=0
    while [ $ok = 0 ]; do
        read -p "Install AWS CLI [y/n]: " INSTALL_AWS
        if [[ "$INSTALL_AWS" = "y" || "$INSTALL_AWS" = "yes" || "$INSTALL_AWS" = "Y" || "$INSTALL_AWS" = "YES" || "$INSTALL_AWS" = "Yes" ]]; then
            INSTALL_AWS="y"
            ok=1
        elif [[ "$INSTALL_AWS" = "n" || "$INSTALL_AWS" = "no" || "$INSTALL_AWS" = "N" || "$INSTALL_AWS" = "NO" || "$INSTALL_AWS" = "No" ]]; then
            INSTALL_AWS="n"
            ok=1
        fi
    done

    ok=0
    while [ $ok = 0 ]; do
        read -p "Install Kubernetes CLI [y/n]: " INSTALL_KUBE
        if [[ "$INSTALL_KUBE" = "y" || "$INSTALL_KUBE" = "yes" || "$INSTALL_KUBE" = "Y" || "$INSTALL_KUBE" = "YES" || "$INSTALL_KUBE" = "Yes" ]]; then
            INSTALL_KUBE="y"
            ok=1
        elif [[ "$INSTALL_KUBE" = "n" || "$INSTALL_KUBE" = "no" || "$INSTALL_KUBE" = "N" || "$INSTALL_KUBE" = "NO" || "$INSTALL_KUBE" = "No" ]]; then
            INSTALL_KUBE="n"
            ok=1
        fi
    done

    ok=0
    while [ $ok = 0 ]; do
        read -p "Install OSQuery [y/n]: " INSTALL_OSQUERY
        if [[ "$INSTALL_OSQUERY" = "y" || "$INSTALL_OSQUERY" = "yes" || "$INSTALL_OSQUERY" = "Y" || "$INSTALL_OSQUERY" = "YES" || "$INSTALL_OSQUERY" = "Yes" ]]; then
            INSTALL_OSQUERY="y"
            ok=1
        elif [[ "$INSTALL_OSQUERY" = "n" || "$INSTALL_OSQUERY" = "no" || "$INSTALL_OSQUERY" = "N" || "$INSTALL_OSQUERY" = "NO" || "$INSTALL_OSQUERY" = "No" ]]; then
            INSTALL_OSQUERY="n"
            ok=1
        fi
    done

    ok=0
    while [ $ok = 0 ]; do
        read -p "Install OpenVAS (Requires 20 GB) [y/n]: " INSTALL_OPENVAS
        if [[ "$INSTALL_OPENVAS" = "y" || "$INSTALL_OPENVAS" = "yes" || "$INSTALL_OPENVAS" = "Y" || "$INSTALL_OPENVAS" = "YES" || "$INSTALL_OPENVAS" = "Yes" ]]; then
            INSTALL_OPENVAS="y"
            ok=1
        elif [[ "$INSTALL_OPENVAS" = "n" || "$INSTALL_OPENVAS" = "no" || "$INSTALL_OPENVAS" = "N" || "$INSTALL_OPENVAS" = "NO" || "$INSTALL_OPENVAS" = "No" ]]; then
            INSTALL_OPENVAS="n"
            ok=1
        fi
    done

    ok=0
    while [ $ok = 0 ]; do
        read -p "Install Suricata [y/n]: " INSTALL_SURICATA
        if [[ "$INSTALL_SURICATA" = "y" || "$INSTALL_SURICATA" = "yes" || "$INSTALL_KUBE" = "Y" || "$INSTALL_SURICATA" = "YES" || "$INSTALL_SURICATA" = "Yes" ]]; then
            INSTALL_SURICATA="y"
            ok=1
        elif [[ "$INSTALL_SURICATA" = "n" || "$INSTALL_SURICATA" = "no" || "$INSTALL_SURICATA" = "N" || "$INSTALL_SURICATA" = "NO" || "$INSTALL_SURICATA" = "No" ]]; then
            INSTALL_SURICATA="n"
            ok=1
        fi
    done
fi

if [[ "$INSTALL_OPENVAS" = "y" ]]; then
    ok=0
    while [ $ok = 0 ]; do
        read -p "Enter full path to ValkureFetch directory [press enter if not using Valkure]: " VALKUREDIR
        if [[ -e $VALKUREDIR/valkure-agent || -z $VALKUREDIR ]]; then
            ok=1
        else
            echo "ERROR: Invalid directory!"
        fi
    done
fi

echo
if [[ "$INSTALL_NMAP" = "n" ]]; then
    echo "Skipping NMAP"
else
    echo "Installing NMAP"
    $installer install nmap
    echo NMAP installation complete
fi

echo
if [[ "$INSTALL_KUBE" = "n" ]]; then
    echo "Skipping Kubernetes CLI"
else
    echo "Installing Kubernetes CLI"
    if [[ "$installer" = "port" ]]; then
        $installer install kubectl-1.22
    else    
        $installer install kubectl
    fi
    echo KubeCTL installation complete
fi

echo
if [[ "$INSTALL_AWS" = "n" ]]; then
    echo "Skipping AWS CLI"
else
    echo "Installing AWS CLI"
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    installer -pkg AWSCLIV2.pkg -target /
    echo AWS CLI installation complete
fi

echo
if [[ "$INSTALL_OSQUERY" = "n" ]]; then
    echo "Skipping OSQuery"
else
    echo "Installing OSQuery"
    curl -L https://pkg.osquery.io/darwin/osquery-5.10.2.pkg -o osquery-5.10.2.pkg
    installer -pkg ~/Downloads/osquery-5.10.2.pkg -target /
    echo OSQuery installation complete
fi

echo
if [[ "$INSTALL_OPENVAS" = "n" ]]; then
    echo "Skipping OpenVAS"
else
    echo "Installing OpenVAS"
    $installer install xmlstarlet
    $installer install docker-compose
    DOCKERDIR=/usr/local/bin
    DOCKERDEST=$DOCKERDIR/docker-compose
    DOCKERVER=1.29.0
    sudo curl -L https://github.com/docker/compose/releases/download/${DOCKERVER}/docker-compose-$(uname -s)-$(uname -m) -o $DOCKERDEST
    sudo chmod 755 $DOCKERDEST

    curl -f -O https://greenbone.github.io/docs/latest/_static/setup-and-start-greenbone-community-edition.sh && chmod u+x setup-and-start-greenbone-community-edition.sh
    ./setup-and-start-greenbone-community-edition.sh
    echo -n "Re-enter password for OpenVAS admin account: "
    read OPENVASPASS
    # echo $OPENVASPASS
    curl -f -L https://greenbone.github.io/docs/latest/_static/docker-compose-22.4.yml -o docker-compose.yml
    docker-compose -f ./docker-compose.yml -p greenbone-community-edition exec -u gvmd gvmd gvmd --user=admin --new-password=$OPENVASPASS
    docker-compose -f ./docker-compose.yml -p greenbone-community-edition run -d --rm gvm-tools

    if [[ -n $VALKUREDIR ]]; then
        sed -i '' "s@/home/stephan/Greenbone@$PWD@" $VALKUREDIR/conf/fetch.onprem.json
    fi
    echo OpenVAS installation complete
fi

echo
if [[ "$INSTALL_SURICATA" = "n" ]]; then
    echo "Skipping Suricata"
else
    echo "Installing Suricata"
    if [[ "$installer" = "brew" ]]; then
        brew install suricata jq
    else
        port install jansson
        curl -f -L https://www.openinfosecfoundation.org/download/suricata-7.0.2.tar.gz -o suricata-7.0.2.tar.gz
        tar xzvf suricata-7.0.2.tar.gz
        cd suricata-7.0.2
        ./configure
        make
        make install
        port install jq
    fi
    echo Suricata installation complete
fi


echo
echo "Installation completed on macOS."

