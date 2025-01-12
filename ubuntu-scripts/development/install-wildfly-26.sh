#!/bin/bash
echo Installing WildFly 26.1.0...
cd ~/Downloads
wget https://github.com/wildfly/wildfly/releases/download/26.1.0.Final/wildfly-26.1.0.Final.zip
unzip wildfly-26.1.0.Final.zip
sudo mv wildfly-26.1.0.Final /opt/