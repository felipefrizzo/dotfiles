#!/bin/zsh
printf "\nSetup MacOSx...\n"

sh install-cli-tools.sh

sh install-homebrew.sh

sudo sh osx-system-defaults.sh
sh osx-user-defaults.sh

sh setup-bash.sh

echo "\nInstalling Fonts"
open -a Font\ Book ./fonts/*.ttf

printf "\nSetup apps on docker..."
sh setup-dock.sh

sh install-zsh.sh
yes | cp -a ./home/ ~/

echo "\nLinking AI agent instructions"
ln -sf ~/.agent-instructions/AGENTS.md ~/.claude/CLAUDE.md
ln -sf ~/.agent-instructions/AGENTS.md ~/.codex/AGENTS.md
ln -sf ~/.agent-instructions/AGENTS.md ~/.copilot/copilot-instructions.md
ln -sf ~/.agent-instructions/RTK.md ~/.claude/RTK.md
ln -sf ~/.agent-instructions/RTK.md ~/.codex/RTK.md

sh setup-powerlevel10k.sh

compaudit | xargs chmod g-w,o-w