#!/bin/bash
echo ""
echo "Installing Java"

sudo add-apt-repository ppa:webupd8team/java
sudo apt update
sudo apt install -y oracle-java9-installer

sudo update-alternatives --config java
