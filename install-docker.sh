#!/bin/bash
echo ""
echo  "Installing Docker"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt update
sudo apt install -y docker-ce

DOCKER_COMPOSE_VERSION='1.14.0'
sudo -i
curl -L 'https://github.com/docker/compose/releases/download/'$DOCKER_COMPOSE_VERSION'/docker-compose-'`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

DOCKER_MACHINE_VERSION='v0.12.2'
curl -L 'https://github.com/docker/machine/releases/download/'$DOCKER_MACHINE_VERSION'/docker-machine-'`uname -s`-`uname -m` >/usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine
