#!/bin/bash
echo ""
echo "Instaling Homebrew"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

#installl homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo ""
echo "Instaling applications from homebrew"

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
brew install nvm
brew install go
brew install pyenv
brew install pyenv-virtualenv

#brew install dockutil
brew install dockutil

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
brew cask install slack

brew cask install java
brew install git-credential-manager

brew cask install virtualbox
brew cask install vmware-fusion
brew cask install vagrant

brew cask install atom
brew cask install intellij-idea-ce
brew cask install pycharm
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
brew cask install docker
#install docker-machine xhyve driver
brew install docker-machine-driver-xhyve

#create /opt/java folder
sudo mkdir -p /opt/java/
sudo chmod 777 /opt/java

echo ""
echo "Cleanup brew"
brew cleanup
brew cask cleanup
