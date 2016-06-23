#!/bin/bash
echo "\nInstaling Homebrew"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

#installl homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "\nInstaling applications from homebrew"

#install homebrew-cask
brew install caskroom/cask/brew-cask

#tap hombrew cask-versions and completions
brew tap caskroom/versions
brew tap homebrew/completions

#install hombrew formulas
brew install dos2unix
brew install git
brew install mercurial
brew install wget
brew install pyenv
brew install pyenv-virtualenv
brew install nvm

# brew install dockutil
brew install https://github.com/keith/homebrew/raw/ks-dockutil/Library/Formula/dockutil.rb

#install hombrew cask formulas
brew cask install utorrent
brew cask install dropbox
brew cask install google-drive

brew cask install google-chrome-canary
brew cask install firefoxdeveloperedition
brew cask install opera-developer

brew cask install spotify
brew cask install the-unarchiver
brew cask install vlc
brew cask install skype

brew cask install java

brew cask install virtualbox
brew cask install vmware-fusion
brew cask install vagrant

brew cask install atom
brew cask install intellij-idea
brew cask install pycharm
brew cask install webstorm
brew cask install postamn

brew cask install sourcetree
brew cask install diffmerge

brew cask install mongochef
brew cask install pgadmin3
brew cask install mysqlworkbench

IS_LAPTOP=`/usr/sbin/system_profiler SPHardwareDataType | grep "Model Identifier" | grep "Book"`
if [[ "$IS_LAPTOP" != "" ]]; then
  brew cask intall coconutbattery
fi

#install homebrew completions
brew install pip-completion
brew install django-completion
brew install vagrant-completion
brew install bash-completion

#install homebrew docker formulas
brew install docker
brew install docker-completion
brew install docker-machine-completion
brew install docker-machine
brew install docker-compose-completion
brew install docker-compose

#create /opt/java folder
sudo mkdir -p /opt/java/
sudo chmod 777 /opt/java
