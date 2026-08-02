#!/bin/zsh
set -eu

printf "\nSetup PowerLevel 10k...\n"
mkdir -p ~/.oh-my-zsh/custom/themes/powerlevel10k
ln -sf /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
