#!/bin/bash
echo Installing Bitwarden...
cd ~/Downloads
wget -c https://github.com/bitwarden/clients/releases/download/desktop-v2024.12.1/Bitwarden-2024.12.1-amd64.deb
sudo apt -y install ./Bitwarden-2024.12.1-amd64.deb