#!/bin/bash
echo
echo Installing Ookla Speed Test...
echo
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt update
sudo apt -y install speedtest-cli