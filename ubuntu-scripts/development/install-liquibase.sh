#!/bin/bash
echo Installing Liquibase...
cd ~/Downloads
wget https://github.com/liquibase/liquibase/releases/download/v4.31.1/liquibase-4.31.1.zip
unzip liquibase-4.31.1.zip -d liquibase-4.31.1
sudo mv liquibase-4.31.1 /opt/
sudo update-alternatives --install /usr/bin/liquibase liquibase /opt/liquibase-4.31.1/liquibase 4311
liquibase -v