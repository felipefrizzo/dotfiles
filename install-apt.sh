#!/bin/sh
echo ""
echo "Install apt"

sudo apt install -f
sudo apt install -y apt-transport-https
sudo apt install -y autojump
sudo apt install -y autojump-zsh
sudo apt install -y ack-grep
sudo apt install -y build-essential
sudo apt install -y ca-certificates
sudo apt install -y cmake
sudo apt install -y curl
sudo apt install -y git
sudo apt install -y git-cola
sudo apt install -y heroku-toolbelt
sudo apt install -y libpq-dev
sudo apt install -y namebench
sudo apt install -y make
sudo apt install -y pandoc
sudo apt install -y postgresql
sudo apt install -y postgresql-contrib
sudo apt install -y pgadmin3
sudo apt install -y python
sudo apt install -y python-dev
sudo apt install -y python-psycopg2
sudo apt install -y python-setuptools
sudo apt install -y python-pip
sudo apt install -y ruby
sudo apt install -y ruby-build
sudo apt install -y silversearcher-ag
sudo apt install -y software-properties-common
sudo apt install -y transmission
sudo apt install -y xclip
sudo apt install -y zsh


# install the fuck
pip install --upgrade pip
sudo -H python -m pip install thefuck

echo ""
echo "Cleanup apt-get"

# clean up
sudo apt autoremove
sudo apt autoclean
