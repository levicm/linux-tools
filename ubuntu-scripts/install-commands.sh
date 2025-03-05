#!/bin/bash
echo Installing HTOP...
sudo apt -y install htop

echo Installing Locate...
sudo apt -y install plocate

echo Installing tree...
sudo apt -y install tree

echo Installing fd-find...
sudo apt -y install fd-find

echo Installing NeoFetch...
sudo apt -y install neofetch

echo Installing FZF...
sudo apt -y install fzf

bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/tool/install-speedtest.sh)
