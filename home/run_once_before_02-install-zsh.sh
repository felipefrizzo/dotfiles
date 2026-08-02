#!/bin/zsh
set -eu

# Must run before chezmoi writes dot_zshrc: the oh-my-zsh installer moves any
# existing ~/.zshrc to ~/.zshrc.pre-oh-my-zsh and drops in its own default,
# which would clobber the managed .zshrc if this ran afterwards instead.
printf "\nInstalling oh-my-zsh...\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
