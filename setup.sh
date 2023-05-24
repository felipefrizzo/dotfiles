#!/bin/zsh
printf "\nSetup MacOSx...\n"

sh install-cli-tools.sh

sh install-homebrew.sh
sh install-vscode-plugins.sh

sudo sh osx-system-defaults.sh
sh osx-user-defaults.sh

mkdir -p ~/.nvm
mkdir -p ~/.pyenv

sudo ln -sf $(brew --prefix bash)/bin/bash /usr/local/bin/bash

echo "\nInstalling Fonts"
open -a Font\ Book ./fonts/*.ttf

printf "\nSetup apps on docker..."
python setup-dock.py
killall Dock

sh install-zsh.sh
yes | cp -a ./home/ ~/
