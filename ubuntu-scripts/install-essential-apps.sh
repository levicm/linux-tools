#!/bin/bash
echo Installing Synaptic...
sudo apt -y install synaptic

echo Installing curl...
sudo apt -y install curl

echo Installing wget...
sudo apt -y install wget

echo Installing NeoFetch...
sudo apt -y install neofetch

echo Installing HTOP...
sudo apt -y install htop

echo Installing Locate...
sudo apt install plocate

echo Installing tree...
sudo apt install tree

echo Installing fd-find...
sudo apt install fd-find

if [[ -f /usr/bin/gnome-session ]]
then 
    echo Installing Gnome-tweaks...
    sudo apt -y install gnome-tweaks

    echo Installing Gnome Shell Extension Manager...
    sudo apt -y install gnome-shell-extension-manager
fi

./tool/install-speedtest.sh

./tool/install-remmina.sh

./tool/install-fsearch.sh

./tool/install-fzf.sh

./tool/install-sublime-text.sh

./internet/install-google-chrome.sh

./security/install-bitwarden.sh

./cloud-storage/install-onedriver.sh