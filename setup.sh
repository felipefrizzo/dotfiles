#!/bin/zsh
printf "\nSetup MacOSx...\n"

sh install-cli-tools.sh

sh install-homebrew.sh

sudo sh osx-system-defaults.sh
sh osx-user-defaults.sh

mkdir -p ~/.nvm
mkdir -p ~/.pyenv

sh setup-bash.sh

echo "\nInstalling Fonts"
open -a Font\ Book ./fonts/*.ttf

printf "\nSetup apps on docker..."
sh setup-dock.sh

sh install-zsh.sh
yes | cp -a ./home/ ~/

sh setup-powerlevel10k.sh

compaudit | xargs chmod g-w,o-w