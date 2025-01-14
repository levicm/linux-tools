#!/bin/bash
if [[ -f /usr/bin/gnome-session ]]
then 
    echo Installing Gnome-tweaks...
    sudo apt -y install gnome-tweaks

    echo Installing Gnome Shell Extension Manager...
    sudo apt -y install gnome-shell-extension-manager
fi

echo Installing Synaptic...
sudo apt -y install synaptic

if [[ -n `which flatpak` ]]
then
    echo Flatpak installed. Installing Gear Lever...
    flatpak install flathub it.mijorus.gearlever
fi

./tool/install-remmina.sh

./tool/install-fsearch.sh

./tool/install-sublime-text.sh

./internet/install-google-chrome.sh

./security/install-bitwarden.sh

./cloud-storage/install-onedriver.sh

