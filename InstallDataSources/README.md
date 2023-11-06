## Install Data Sources to work with Valkure

This directory contains scripts to install the following data sources and configure them to work with Valkure: AWS CLI, Kubernetes CLI (KubeCTL), NMAP, OpenVAS, OSQuery, and Suricata. Note that in all cases, Valkure calls these programs through their own documented APIs for the downloaded versions.

# Linux

Run the executable

> ./install-data-sources.sh [all]

If you run with the optional "all" argument, all data sources will be installed. If not, you will be prompted as to which data sources you'd like to install. 

# Windows

On Windows, you must install each program individually in the Powershell (administrator privielges are *not* necessary). Run each script with the command:

> .\install-<datasource>-windows.bat

where <datasource> = aws, nmap, etc. Note that after each installation, you must reboot your machine.

# Apple

Coming soon!