#!/bin/bash
echo Installing WildFly 34.0.1...
cd ~/Downloads
wget https://github.com/wildfly/wildfly/releases/download/34.0.1.Final/wildfly-34.0.1.Final.zip
unzip wildfly-34.0.1.Final.zip
sudo mv wildfly-34.0.1.Final /opt/