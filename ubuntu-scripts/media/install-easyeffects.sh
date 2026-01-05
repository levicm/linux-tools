#!/bin/bash
# EasyEffects por repositório (normalmente tem versão mais antiga que por flatpak)
echo Installing EasyEffects...
sudo apt install -y easyeffects
# Se Gnome, instala extensão para controle de mídia, necessário quando instalado por repositório
if [[ -f /usr/bin/gnome-session ]]
then 
    echo This is a Gnome system!
    echo Installing Gnome Extensions for media control...

    if ! command -v gext &> /dev/null
    then
        echo "gnome-extensions-cli (gext) could not be found, installing it first..."
        bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/install-gnome-extensions.sh)
    fi
    gext install eepresetselector@ulville.github.io
fi
