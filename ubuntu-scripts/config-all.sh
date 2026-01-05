#!/bin/bash
echo This script runs many other scripts to configure your environment as described:
echo 
echo - prepare-linux.sh: prepare de linux environment configuring the Real Time Clock to locate \(same as Windows\) and update your system.
echo - install-commands.sh: install basic terminal commands as curl, wget, fd-find, etc.
echo - install-essential-apps.sh: install essential applications gnome-tweaks, gnome-shell-extension-manager, remina, Google Chrome, Sublime Text, BitWarden, etc.
echo - install-dev-tools.sh: install tools for developers as GIT, Python, Visual Studio Code, Eclipse and Postman.
echo - install-media-apps.sh: install media apps as Spotify.
echo - install-gnome-extensions.sh: install some gnome extensions as CPU Power Manager, Sound Input \& Output Device Chooser, Tiling Shell, User Themes and Extensions List.
echo
read -r -p "Do you want to run all the scripts to configure your environment? [y/N]" response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/prepare-linux.sh)

    bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/install-commands.sh)

    bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/install-essential-apps.sh)

    bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/install-dev-tools.sh)

    bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/install-media-apps.sh)

    bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/install-gnome-extensions.sh)

    bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/install-office-apps.sh)

    bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/install-ttf-fonts.sh)

    bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/install-nautilus-extensions.sh)

    echo Cleaning packages...
    sudo apt autoremove
fi
