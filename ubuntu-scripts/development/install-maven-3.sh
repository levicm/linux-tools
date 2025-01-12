#!/bin/bash
echo Installing Maven 3.9.9...
cd ~/Downloads
wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.zip
unzip apache-maven-3.9.9-bin.zip
sudo mv apache-maven-3.9.9 /opt/
sudo update-alternatives --install /usr/bin/mvn maven /opt/apache-maven-3.9.9/bin/mvn 399
mvn -v