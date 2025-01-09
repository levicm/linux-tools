#!/bin/bash
# tar: https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.tar.gz
# Baixa o pacote
echo Installing Oracle JDK 17...
cd ~/Downloads
wget https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.deb
# Instala o pacote
sudo apt install ./jdk-17.0.12_linux-x64_bin.deb
# Define variável de ambiente JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/jdk-17.0.12-oracle-x64
# Adiciona os links simbólicos para a nova instalação
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-17.0.12-oracle-x64/bin/java 17
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-17.0.12-oracle-x64/bin/javac 17
sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk-17.0.12-oracle-x64/bin/jar 17
# Verifica configuração dos links simbólicos. Se só tiver uma versão, não precisará fazer nada
sudo update-alternatives --config java
sudo update-alternatives --config javac
sudo update-alternatives --config jar
