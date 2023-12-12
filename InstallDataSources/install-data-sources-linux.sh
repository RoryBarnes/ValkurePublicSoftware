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
    ok=1

    if [ -e /etc/os-release ]; then
        # Source the os-release file
        . /etc/os-release

        # Check if the ID variable is present
        if [ -n "$ID" ]; then
            
            # Check if the ID is either "ubuntu" or "debian"
            if [ "$ID" == "ubuntu" ] || [ "$ID" == "debian" ]; then
                INSTALLER=apt-get
                DISTRO=Debian

            elif [ "$ID" == "rhel" ] || [ "$ID" == "amzn" ]; then
                INSTALLER=yum
                DISTRO=RedHat
            fi
        fi
    fi
elif [[ "${OSTYPE:0:6}" = "darwin" ]]; then
  PLATFORM=osx-x64
elif [[ "$OSTYPE" = "msys" ]]; then
  PLATFORM=win-x64
elif [[ "$OSTYPE" = "win32" ]]; then
  PLATFORM=win-x64
else
  echo "Unsupported platform!"
  echo
  exit 1
fi

if [[ $ok = 0 ]]; then
    echo
    echo ERROR: Incorrect operating system for this script
    if [[ "$PLATFORM" = "osx-x64" ]]; then
        echo Use script install-data-sources-macos.sh
    elif [[ "$PLATFORM" = "win-x64" ]]; then
        echo Use script install-data-sources-windows.sh
    fi
    echo
    exit 1
fi


if [[ "$DISTRO" = "unknown" ]]; then
    echo
    echo "Unable to determine the operating system."
    echo
    echo "  1. apt-get"
    echo "  2. yum"
    echo "  3. other"
    echo

    ok=0
    while [ $ok = 0 ]
    do
        echo -n "Enter the installer you use [1,2,3]: "
        read INSTALL_ID
        if [[ "$INSTALL_ID" = "1" ]]; then
            INSTALLER=apt-get
            ok=1
        elif [[ "$INSTALL_ID" = "2" ]]; then
            INSTALLER=yum
            ok=1
        elif [[ "$INSTALL_ID" = "3" ]]; then
            echo
            echo "Sorry, this script will not work with your Linux distribution."
            echo
            exit 1
        fi
    done
fi

echo
echo Installing Valkure Data Sources on $DISTRO distribution of $PLATFORM.
echo

sudo $INSTALLER install curl

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

    if [[ "$ID" = "amzn" ]]; then
        echo Running on AWS, not installing AWS CLI
        INSTALL_AWS="n"
    else
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
    fi

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
        if [[ "$INSTALL_SURICATA" = "y" || "$INSTALL_SURICATA" = "yes" || "$INSTALL_SURICATA" = "Y" || "$INSTALL_SURICATA" = "YES" || "$INSTALL_SURICATA" = "Yes" ]]; then
            INSTALL_SURICATA="y"
            ok=1
        elif [[ "$INSTALL_SURICATA" = "n" || "$INSTALL_SURICATA" = "no" || "$INSTALL_SURICATA" = "N" || "$INSTALL_SURICATA" = "NO" || "$INSTALL_SURICATAS" = "No" ]]; then
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
        if [[ -e $VALKUREDIR/valkure-agent || -z $VALKUREDIR ]]; then
            ok=1
        else
            echo ERROR: Invalid directory!
        fi
    done

    DOCKERSTATUS=$(sudo docker ps)
    if [ -z "$DOCKERSTATUS" ]; then
        echo
        echo OpenVAS requires Docker to be running.
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
    fi
fi

echo
if [[ "$INSTALL_NMAP" = "n" ]]; then
    echo Skipping NMAP
else
    echo Installing NAMP
    sudo $INSTALLER install nmap
fi

echo
if [[ "$INSTALL_KUBE" = "n" ]]; then
    echo Skipping Kubernetes CLI
else
    echo Installing Kubernetes CLI
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo mv kubectl /usr/bin
    sudo chmod u+x /usr/bin/kubectl
fi

# #sudo $INSTALLER update -y
# sudo $INSTALLER install -y ca-certificates curl
# #sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg > https://packages.cloud.google.com/apt/doc/apt-key.gpg
# curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg]  https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# #sudo $INSTALLER update -y
# sudo $INSTALLER install -y kubectl

echo
if [[ "$INSTALL_AWS" = "n" ]]; then
    echo Skipping AWS CLI
else
    echo Installing AWS CLI
    sudo hwclock -s
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

echo
if [[ "$INSTALL_OSQUERY" = "n" ]]; then
    echo Skipping OSQuery
else
    echo Installing OSQuery
    if [[ "$INSTALLER" = "apt-get" ]]; then
        export OSQUERY_KEY=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $OSQUERY_KEY
        sudo add-apt-repository 'deb [arch=amd64] https://pkg.osquery.io/deb deb main' -y
        sudo apt-get install osquery
    else
        sudo yum install yum-utils
        curl -L https://pkg.osquery.io/rpm/GPG | sudo tee /etc/pki/rpm-gpg/RPM-GPG-KEY-osquery
        sudo yum-config-manager --add-repo https://pkg.osquery.io/rpm/osquery-s3-rpm.repo
        sudo yum-config-manager --enable osquery-s3-rpm-repo
        sudo yum install osquery
    fi
fi

echo
if [[ "$INSTALL_OPENVAS" = "n" ]]; then
    echo Skipping OpenVAS
else
    echo Installing OpenVAS
    
    if [[ "$INSTALL_DOCKER" = "y" ]]; then
        echo Installing Docker
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
    fi

    if [ -z "$DOCKERSTATUS" ]; then
        DockerRunning=0
        if [[ "$DISTRO" = "Debian" ]]; then
            sudo service docker start
        elif [[ "$DISTRO" = "RedHat" ]]; then
            sudo systemctl start docker
        else
            echo Unable to stat Docker service.
        fi

        sleep 5
        NewDockerStatus=$(sudo docker ps)
        if [ -z "$DOCKERSTATUS" ]; then
            echo Unable to start Docker. Skipping OpenVas
        fi
    else
        DockerRunning=1
    fi    

    if [[ $DockerRunning = 1 ]]; then
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
fi

echo
if [[ "$INSTALL_SURICATA" = "n" ]]; then
    echo Skipping Suricata
else
    echo Installing Suricata
    if [[ "$DISTRO" = "Debian" ]]; then
        sudo mkdir -p /etc/apt/keyrings
        sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
        sudo apt update && sudo apt upgrade
        sudo apt-get update && sudo apt-get upgrade
        sudo add-apt-repository ppa:oisf/suricata-stable -y
        sudo apt update
        sudo apt install suricata jq -y
    else
        curl -OL https://www.openinfosecfoundation.org/download/suricata-5.0.0.tar.gz
        tar xvf suricata-5.0.0.tar.gz
        cd suricata-5.0.0
        sudo ./configure --sysconfdir=/etc --localstatedir=/var
        sudo make
        sudo make install
        sudo make install-conf
    fi
fi

