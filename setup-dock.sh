#!/bin/zsh

echo "\nSetup apps on dock..."

ASSET=$(curl -s https://api.github.com/repos/kcrawford/dockutil/releases/latest | jq '.assets[0]')
URL=$(jq -r '.browser_download_url' <<< $ASSET)
FILE=$(jq -r '.name' <<< $ASSET)

curl -L  $URL -o $FILE
sudo installer -pkg $FILE -target /
python3 setup-dock.py
killall Dock
rm -rf $FILE