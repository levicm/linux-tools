#!/bin/bash
# Notion not working
#echo Installing Notion...
#echo "deb [trusted=yes] https://apt.fury.io/notion-repackaged/ /" | sudo tee /etc/apt/sources.list.d/notion-repackaged.list
#sudo apt update
#sudo apt -y install notion-app

echo Installing PDF Sam...
sudo apt -y install pdfsam

bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/office/install-wps.sh)
