#!/bin/bash
echo Installing Bitwarden...
cd ~/Downloads
wget https://github.com/bitwarden/clients/releases/download/desktop-v2024.12.1/Bitwarden-2024.12.1-amd64.deb
sudo apt install ./Bitwarden-2024.12.1-amd64.deb