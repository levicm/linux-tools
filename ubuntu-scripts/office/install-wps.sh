#!/bin/bash
echo Installing WPS Office...
cd ~/Downloads
wget https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/11723/wps-office_11.1.0.11723.XA_amd64.deb
if [[ -f wps-office_11.1.0.11723.XA_amd64.deb ]]
then
    sudo dpkg -i wps-office_*.deb

    if [[ ! -f /usr/lib/x86_64-linux-gnu/libtiff.so.5 ]]
    then 
        echo WPS uses libtiff.so.5 but it was not found. Creating a symlink to it...
        cd /usr/lib/x86_64-linux-gnu
        sudo ln -s libtiff.so.6 libtiff.so.5
    fi
fi


