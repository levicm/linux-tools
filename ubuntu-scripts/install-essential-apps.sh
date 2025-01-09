#!/bin/bash
echo Installing Synaptic...
sudo apt-fast -y install synaptic

echo Installing curl...
sudo apt-fast -y install curl

echo Installing wget...
sudo apt-fast -y install wget

echo Installing NeoFetch...
sudo apt-fast -y install neofetch

echo Installing HTOP...
sudo apt-fast -y install htop

echo Installing Locate...
sudo apt-fast install plocate

if [[ -f /usr/bin/gnome-session ]]
then 
    echo Installing Gnome-tweaks...
    sudo apt-fast -y install gnome-tweaks

    echo Installing Gnome Shell Extension Manager...
    sudo apt-fast -y install gnome-shell-extension-manager
fi

./tool/install-remmina.sh

./tool/install-fsearch.sh

./internet/install-google-chrome.sh

./security/install-bitwarden.sh

./cloud-storage/install-onedriver.sh