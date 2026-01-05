#!/bin/bash
sudo apt install -y openjdk-21-jdk

# Define variável de ambiente JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
# Adiciona os links simbólicos para a nova instalação
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-21-openjdk-amd64/bin/java 21
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-21-openjdk-amd64/bin/javac 21
sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/java-21-openjdk-amd64/bin/jar 21
# Define a configuração dos links simbólicos para a versão instalada
sudo update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-21-openjdk-amd64/bin/javac
sudo update-alternatives --set jar /usr/lib/jvm/java-21-openjdk-amd64/bin/jar
# Verifica configuração dos links simbólicos. Se só tiver uma versão, não precisará fazer nada
sudo update-alternatives --config java
sudo update-alternatives --config javac
sudo update-alternatives --config jar
