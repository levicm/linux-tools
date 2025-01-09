#!/bin/bash
# tar: https://cfdownload.adobe.com/pub/adobe/coldfusion/java/java11/java11025/jdk-11.0.25_linux-x64_bin.tar.gz
# Baixa o pacote
echo Installing Oracle JDK 11...
cd ~/Downloads
wget -c https://cfdownload.adobe.com/pub/adobe/coldfusion/java/java11/java11025/jdk-11.0.25_linux-x64_bin.deb
# Instala o pacote
sudo apt install ./jdk-11.0.25_linux-x64_bin.deb
# Define variável de ambiente JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/jdk-11.0.25-oracle-x64
# Adiciona os links simbólicos para a nova instalação
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-11.0.25-oracle-x64/bin/java 11
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-11.0.25-oracle-x64/bin/javac 11
sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk-11.0.25-oracle-x64/bin/jar 11
# Verifica configuração dos links simbólicos. Se só tiver uma versão, não precisará fazer nada
sudo update-alternatives --config java
sudo update-alternatives --config javac
sudo update-alternatives --config jar
