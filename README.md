# PublicSoftware
All public software available to Valkure customers

The directory InstallDataSources contains a script to install the following open source applications related to network operations and security:

- NMAP
- AWS CLI
- Kubernetes CLI (KubeCTL)
- OSQuery
- OpenVAS
- Suricata (coming soon)

This script will install these scripts in a manner that enables Valkure to execute them, but note that you do not need to have installed Valkure to take advantage of this script.

Once installed, run

> ./install-data-sources.sh [all]

where the "all" argument is optional. If you do not include that argument, then you will be prompted to select which application(s) you want to install. Adding the "all" argument will install them all.