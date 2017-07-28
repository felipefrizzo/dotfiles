#!/bin/bash
echo ""
echo  "Installing VirtualBox"

VERSION='5.1.26'
RELEASE='virtual-box-amd64.deb'
curl -L 'http://download.virtualbox.org/virtualbox/'$VERSION'/virtualbox-5.1_'$VERSION'-117224~Debian~stretch_amd64.deb' -o $HOME/Downloads/$RELEASE
sudo dkpg --install ~/Downloads/$RELEASE
