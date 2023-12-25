#!/bin/zsh
printf "\nSetup Bash...\n"

eval "$(/opt/homebrew/bin/brew shellenv)"
sudo ln -sf $(brew --prefix bash)/bin/bash /usr/local/bin/bash