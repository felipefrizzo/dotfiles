#!/bin/zsh
chmod go-w "$(brew --prefix)/share"

printf "\nInstalling oh-my-zsh...\n"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

printf "\nInstalling zsh plugins and themes...\n"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k