#!/bin/bash
echo Setting date do local time, like Windows does...
timedatectl set-local-rtc 1 --adjust-system-clock
timedatectl

sudo apt update

echo Installing apt-fast..
sudo add-apt-repository ppa:apt-fast/stable
sudo apt update
sudo apt -y install apt-fast

echo Updating system \(now in parallel\)...
sudo apt update
sudo apt-fast upgrade

echo Installing Ubuntu Restricted Extras \(https://en.wikipedia.org/wiki/Ubuntu-restricted-extras\)...
sudo apt-fast -y install ubuntu-restricted-extras
