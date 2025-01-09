#!/bin/bash
# tar: https://download.oracle.com/java/20/archive/jdk-20.0.2_linux-x64_bin.tar.gz
# Baixa o pacote
echo Installing Oracle JDK 20...
cd ~/Downloads
wget -c https://download.oracle.com/java/20/archive/jdk-20.0.2_linux-x64_bin.deb 
# Instala o pacote
sudo apt install ./jdk-20.0.2_linux-x64_bin.deb
# Define variável de ambiente JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/jdk-20
# Adiciona os links simbólicos para a nova instalação
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-20/bin/java 20
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-20/bin/javac 20
sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk-20/bin/jar 20
# Verifica configuração dos links simbólicos. Se só tiver uma versão, não precisará fazer nada
sudo update-alternatives --config java
sudo update-alternatives --config javac
sudo update-alternatives --config jar
