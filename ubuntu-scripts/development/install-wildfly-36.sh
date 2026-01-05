#!/bin/bash
echo Installing WildFly 36.0.1...
cd ~/Downloads
wget https://github.com/wildfly/wildfly/releases/download/36.0.1.Final/wildfly-36.0.1.Final.zip
unzip wildfly-36.0.1.Final.zip
sudo mv wildfly-36.0.1.Final /opt/