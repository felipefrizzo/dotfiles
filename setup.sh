#!/bin/zsh
printf "\nSetup MacOSx...\n"

sh install-cli-tools.sh

sh install-homebrew.sh
sh install-vscode-plugins.sh

sudo sh osx-system-defaults.sh
sh osx-user-defaults.sh

cp .aliases ~/
cp .gitconfig ~/
cp .gitignore_global ~/
cp .inputrc ~/
cp .p10k.zsh ~/
cp .zprofile ~/
cp .vimrc ~/
cp .switch_version ~/

cp iterm/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
cp vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

mkdir -p ~/.nvm
mkdir -p ~/.pyenv

echo "\nInstalling Fonts"
open -a Font\ Book ./fonts/*.ttf

printf "\nSetup apps on docker..."
python setup-dock.py
killall Dock

sh install-zsh.sh
cp .zshrc ~/
