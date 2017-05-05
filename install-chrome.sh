#!/bin/bash
echo ""
echo  "Installing Google Chrome"

RELEASE='google-chrome.deb'
curl -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o $HOME/Downloads/$RELEASE
sudo dpkg --install ~/Downloads/$RELEASE
