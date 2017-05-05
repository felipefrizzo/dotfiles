#!/bin/bash
echo ""
echo  "Installing Git Kraken"

RELEASE='gitkraken-amd64.deb'
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb -O $HOME/Downloads/$RELEASE
sudo dpkg --install ~/Downloads/$RELEASE
