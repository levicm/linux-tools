#!/bin/bash
echo
echo Installing Ookla Speed Test...
echo
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt update
sudo apt -y install speedtest-cli
# Remove the repository from the sources list because it is problematic
sudo rm /etc/apt/sources.list.d/ookla_speedtest-cli.list