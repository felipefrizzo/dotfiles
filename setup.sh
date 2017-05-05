#!/bin/bash
echo ""
echo "Setup Linux"

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

sudo sh install-apt.sh

echo ""
echo "Setup Developer Tools"
echo ""
sudo sh install-java.sh
sudo sh install-golang.sh
sudo sh install-pyenv.sh
sudo sh install-nvm.sh
sudo sh install-rbenv-rvm.sh
sudo sh install-terraform.sh

echo ""
echo "Setup Text Editors"
echo ""
sudo sh install-atom.sh
sudo sh install-visual-studio.sh
sudo sh install-sublime.sh

echo ""
echo "Setup Browsers"
echo ""
sudo sh install-chrome.sh
sudo sh install-opera.sh

echo ""
echo "Setup Utility"
echo ""
sudo sh install-spotify.sh
sudo sh install-skype-beta.sh
sudo sh install-gitkraken.sh

pip install --upgrade pip
sh install-aws.sh

cp .aliases ~/
cp .bash_completion ~/
cp .bash_prompt ~/
cp .bash_profile ~/
cp .bashrc ~/
cp .inputrc ~/
cp .gitconfig ~/
cp .gitignore_global ~/

mkdir -p ~/.atom
cp config.cson ~/.atom
cp snippets.cson ~/.atom
cp keymap.cson ~/.atom

sudo sh install-atom-plugins.sh
sudo sh install-docker.sh

source $HOME/.bashrc

pyenv install 3.5.0
pyenv global 3.5.0
