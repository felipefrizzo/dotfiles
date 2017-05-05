#!/bin/bash
echo ""
echo  "Installing Atom"

RELEASE='atom-adm64.deb'
curl -L https://atom.io/download/deb -o $HOME/Downloads/$RELEASE
sudo dpkg --install ~/Downloads/$RELEASE
