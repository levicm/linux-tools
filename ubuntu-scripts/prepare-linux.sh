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
sudo apt upgrade

echo Installing Ubuntu Restricted Extras \(https://en.wikipedia.org/wiki/Ubuntu-restricted-extras\)...
sudo apt -y install ubuntu-restricted-extras

echo Installing Flatpak...
sudo apt -y install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo Installing curl...
sudo apt -y install curl

echo Installing wget...
sudo apt -y install wget

echo Installing GIT...
sudo apt -y install git

echo Installing Python3 and pip...
sudo apt -y install python3
sudo apt -y install python3-pip

echo Installing PDF printer...
sudo apt -y install printer-driver-cups-pdf
