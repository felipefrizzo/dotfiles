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

echo "\nInstalling mise-managed toolchains (node/python/go/java)"
mise install

echo "\nLinking AI agent instructions"
ln -sf ~/.agent-instructions/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/.agent-instructions/AGENTS.md ~/.codex/AGENTS.md
ln -sf ~/.agent-instructions/AGENTS.md ~/.copilot/copilot-instructions.md
ln -sf ~/.agent-instructions/RTK.md ~/.claude/RTK.md
ln -sf ~/.agent-instructions/RTK.md ~/.codex/RTK.md

echo "\nInstalling third-party agent skills"
while IFS= read -r source; do
  case "$source" in
    ''|'#'*) continue ;;
  esac
  npx --yes skills@latest add $source
done < ~/skills-manifest.txt

echo "\nInstalling caveman skill (Claude Code / Codex / Copilot / Cursor / etc.)"
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash

echo "\nInstalling iTerm2 dynamic profile"
mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
cp iterm/dynamic-profile.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/felipefrizzo.json

sh setup-powerlevel10k.sh

compaudit | xargs chmod g-w,o-w