#!/bin/bash
echo Installing Docker...

# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo Configuring Docker to run without sudo...
sudo usermod -aG docker $USER
newgrp docker


# Docker Hub certificate
echo Installing DockerHub certificate...
openssl s_client -showcerts -connect registry-1.docker.io:443 </dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > docker.com.crt
sudo cp docker.com.crt /usr/local/share/ca-certificates/
# atualiza os certificados do sistema copiados para /usr/local/share/ca-certificates/
sudo apt-get install -y ca-certificates
sudo update-ca-certificates
# os certificados copiados para /etc/docker/certs.d/ serão utilizados diretamente pelo Docker
sudo mkdir -p /etc/docker/certs.d/registry-1.docker.io/
sudo cp docker.com.crt /etc/docker/certs.d/registry-1.docker.io/
