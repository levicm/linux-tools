#!/bin/bash
echo Installing Bitwarden...

# Instala pacote .deb oficial, mas não atualiza automaticamente
#cd ~/Downloads
#wget -c https://github.com/bitwarden/clients/releases/download/desktop-v2024.12.1/Bitwarden-2024.12.1-amd64.deb
#sudo apt -y install ./Bitwarden-2024.12.1-amd64.deb

# Instala via Flatpak, atualiza automaticamente
flatpak install flathub com.bitwarden.desktop -y