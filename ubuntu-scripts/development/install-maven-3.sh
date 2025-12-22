#!/bin/bash
echo Installing Maven 3.9.10...

# Get the latest Maven 3.9.x version number
MAVEN_VERSION=$(curl -fsSL \
  https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/maven-metadata.xml \
  | grep -oP '(?<=<version>)3\.9\.[0-9]+' \
  | sort -V \
  | tail -n 1)

echo "Downloading Maven $MAVEN_VERSION..."
original_dir=$(pwd)
cd ~/Downloads
wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip
unzip apache-maven-${MAVEN_VERSION}-bin.zip
sudo mv apache-maven-${MAVEN_VERSION} /opt/
sudo update-alternatives --install /usr/bin/mvn maven /opt/apache-maven-${MAVEN_VERSION}/bin/mvn 3900
mvn -v
cd "$original_dir"