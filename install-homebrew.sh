#!/bin/zsh
printf "\nInstalling Homebrew\n"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Installl Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

printf "\nInstalling applications from homebrew\n"

brew tap homebrew/bundle
brew bundle

printf "\n Cleanup brew formulas\n"
brew cleanup