#!/bin/sh
echo ""
echo "Install golang"

sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install -y golang-go
