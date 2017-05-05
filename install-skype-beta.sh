#!/bin/bash
echo ""
echo  "Installing Skype beta"

dpkg -s apt-transport-https > /dev/null || bash -c "sudo apt update; sudo apt install apt-transport-https -y" 
curl https://repo.skype.com/data/SKYPE-GPG-KEY | sudo apt-key add - 
echo "deb [arch=amd64] https://repo.skype.com/deb stable main" | sudo tee /etc/apt/sources.list.d/skype-stable.list 
sudo apt update 
sudo apt install -y skypeforlinux
