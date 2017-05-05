#!/bin/bash
echo ""
echo  "Installing Opera Developer"

sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free'
wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
sudo apt update
sudo apt install -y opera-developer
