#!/bin/bash
echo ""
echo  "Installing Rbenv or RVM"

sudo apt install -y git-core zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

@confirm() {
  local message="$1"

  echo -n "> $message (y/n)"

  while true ; do
    read -s -n 1 choice
    case "$choice" in
      y|Y ) echo "Y" ; return 0 ;;
      n|N ) echo "N" ; return 1 ;;
    esac
  done
}

if @confirm 'If you want install rbenv type (Y) or (N) to install rvm\n' ; then
  echo "Installing Rbenv"
  git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv
  git clone git://github.com/sstephenson/ruby-build.git $HOME/.rbenv/plugins/ruby-build
else
  echo "Installing RVM"
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  \curl -sSL https://get.rvm.io | bash -s stable --rails
fi
