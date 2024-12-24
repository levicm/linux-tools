#!/bin/bash
sudo apt update

# Instalar apt-fast
sudo add-apt-repository ppa:apt-fast/stable
sudo apt update
sudo apt -y install apt-fast

# Atualizar o sistema (agora em paralelo)
sudo apt-fast update
sudo apt-fast upgrade

# Instalar Ubuntu Restricted Extras (https://en.wikipedia.org/wiki/Ubuntu-restricted-extras) 
sudo apt-fast -y install ubuntu-restricted-extras

# Instalar Gerenciador de pacotes Synaptic
sudo apt-fast -y install synaptic

