#!/bin/bash
sudo apt update

echo Installing apt-fast..
sudo add-apt-repository ppa:apt-fast/stable
sudo apt update
sudo apt -y install apt-fast

echo Updating system (now in parallel)
sudo apt-fast update
sudo apt-fast upgrade

echo Installing Ubuntu Restricted Extras (https://en.wikipedia.org/wiki/Ubuntu-restricted-extras) 
sudo apt-fast -y install ubuntu-restricted-extras

echo Installing Synaptic...
sudo apt-fast -y install synaptic

echo Installing curl...
sudo apt-fast install curl

echo Installing wget...
sudo apt-fast install wget

echo Installing Gnome-tweaks...
sudo apt-fast install gnome-tweaks

echo Installing Gnome Shell Extension Manager...
sudo apt-fast -y install gnome-shell-extension-manager