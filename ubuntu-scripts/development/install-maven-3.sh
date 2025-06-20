#!/bin/bash
echo Installing Maven 3.9.10...
cd ~/Downloads
wget https://dlcdn.apache.org/maven/maven-3/3.9.10/binaries/apache-maven-3.9.10-bin.zip
unzip apache-maven-3.9.10-bin.zip
sudo mv apache-maven-3.9.10 /opt/
sudo update-alternatives --install /usr/bin/mvn maven /opt/apache-maven-3.9.10/bin/mvn 3910
mvn -v