#!/bin/bash
echo ""
echo  "Installing Rbenv or RVM"

sudo apt install -y git-core zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv
git clone git://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build

# gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# \curl -sSL https://get.rvm.io | bash -s stable --rails
