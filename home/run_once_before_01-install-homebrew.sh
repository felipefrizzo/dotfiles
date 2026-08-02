#!/bin/zsh
set -eu

printf "\nInstalling Homebrew\n"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
