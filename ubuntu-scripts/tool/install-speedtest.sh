#!/bin/bash
echo Installing Ookla Speed Test...
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt install speedtest
