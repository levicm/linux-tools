#!/bin/bash
echo Installing curl...
sudo apt -y install curl

echo Installing wget...
sudo apt -y install wget

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

./tool/install-speedtest.sh

./tool/install-fzf.sh