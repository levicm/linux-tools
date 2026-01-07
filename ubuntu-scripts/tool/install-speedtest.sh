#!/bin/bash
echo
echo Installing Ookla Speed Test...
echo
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt update
sudo apt -y install speedtest

if [ $? -ne 0 ]; then 
    echo "Falhou via apt, instalando manualmente..." 
    original_dir=$(pwd)
    cd ~/Downloads
    wget https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz
    tar -xvzf ookla-speedtest-1.2.0-linux-x86_64.tgz
    sudo mv speedtest /usr/local/bin/
    cd $original_dir
fi