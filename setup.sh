#!/bin/bash
echo ""
echo "Setup OsX"

sh install-cli-tools.sh
sh install-homebrew.sh
sh install-atom-plugins.sh
sh install-external-softwares.sh

sh update-permission.sh
sh symlinks.sh

sudo sh osx-system-defaults.sh
sh osx-user-defaults.sh

cp .bash_completion ~/
cp .bash_prompt ~/
cp .bash_profile ~/
cp .inputrc ~/
cp .gitconfig ~/
cp .gitignore_global ~/

echo ""
echo "Software Update"
softwareupdate -iva --verbose

echo ""
echo "Setup app's on dock"
python setup-dock.py
killall Dock

mkdir -p ~/.atom
cp config.cson ~/.atom
cp snippets.cson ~/.atom
cp keymap.cson ~/.atom
