#!/bin/sh
echo ""
echo "Installing Vagrant"

VERSION='1.9.7'
RELEASE='vagrant_'$VERSION'_amd64.deb'
curl -L 'https://releases.hashicorp.com/vagrant/'1.9.7'/vagrant_'$VERSION'_x86_64.deb?_ga=2.164785087.1829896918.1501251367-1028559955.1501251367' -o $HOME/Downloads/$RELEASE
sudo dpkg --install ~/Downloads/$RELEASE
