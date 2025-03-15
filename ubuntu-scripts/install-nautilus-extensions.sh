#!/bin/bash
if [[ -f /usr/bin/gnome-session ]]; then
    # flush stdin
    while read -r -t 0; do read -r; done 
    read -p "Continue with installation of Nautilus extensions? [Y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo Installing Nautilus Extensions...
        sudo apt install libnautilus-extension4

        echo Installing Nautilus Scripts...
        cd ~/Downloads
        git clone https://github.com/cfgnunes/nautilus-scripts.git
        cd nautilus-scripts/
        bash install.sh

        echo Installing Nautilus Admin...
        sudo apt install nautilus-admin

        echo Installing VSCode Workspaces...
        bash <(wget -qO- https://raw.githubusercontent.com/ZanzyTHEbar/vscode-workspaces/main/install.sh)

        echo Installing Nautilus ImageMagick...
        sudo apt install imagemagick 

        echo Installing Nautilus Image Converter...
        sudo apt install nautilus-image-converter

        echo Creating Templates directory...
        mkdir ~/Templates
        touch ~/Templates/Textfile.txt

        echo Installation Finished!
    fi
else
    echo This is not a Gnome system!
fi

