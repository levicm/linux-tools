#!/bin/bash
if [[ -f /usr/bin/gnome-session ]]
then 
    echo Installing Gnome-tweaks...
    sudo apt -y install gnome-tweaks

    echo Installing Gnome Shell Extension Manager...
    sudo apt -y install gnome-shell-extension-manager

    echo Installing Alacarte Gnome Menu Editor...
    sudo apt -y install alacarte
fi

echo Installing Synaptic...
sudo apt -y install synaptic

if [[ -n `which flatpak` ]]
then
    echo Flatpak installed. Installing Gear Lever...
    flatpak install flathub it.mijorus.gearlever
fi

bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/tool/install-remmina.sh)

bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/tool/install-fsearch.sh)

bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/tool/install-sublime-text.sh)

bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/internet/install-google-chrome.sh)

bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/security/install-bitwarden.sh)

bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/cloud-storage/install-onedriver.sh)

