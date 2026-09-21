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
mkdir -p ~/.config/opencode
ln -sf ~/.agent-instructions/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/.agent-instructions/AGENTS.md ~/.claude/AGENTS.md
ln -sf ~/.agent-instructions/AGENTS.md ~/.codex/AGENTS.md
ln -sf ~/.agent-instructions/AGENTS.md ~/.copilot/copilot-instructions.md
ln -sf ~/.agent-instructions/AGENTS.md ~/.config/opencode/AGENTS.md
ln -sf ~/.agent-instructions/RTK.md ~/.claude/RTK.md
ln -sf ~/.agent-instructions/RTK.md ~/.codex/RTK.md
ln -sf ~/.agent-instructions/RTK.md ~/.config/opencode/RTK.md

echo "\nInstalling third-party agent skills"
while IFS= read -r source; do
  case "$source" in
    ''|'#'*) continue ;;
  esac
  npx --yes skills@latest add -g -y $source </dev/null
done < ~/skills-manifest.txt

echo "\nInstalling owned eng-phase skill and named agents"
mkdir -p ~/.cursor/agents ~/.cursor/skills ~/.agents/skills ~/.codex/agents ~/.codex/skills ~/.config/opencode/agents ~/.config/opencode/skills
if [ -d ~/.claude/agents ]; then
  cp -a ~/.claude/agents/. ~/.cursor/agents/
  python3 "$(dirname "$0")/scripts/md-agents-to-codex-toml.py" ~/.claude/agents ~/.codex/agents
  python3 "$(dirname "$0")/scripts/md-agents-to-opencode.py" ~/.claude/agents ~/.config/opencode/agents
fi
if [ -d ~/.claude/skills/eng-phase ]; then
  cp -a ~/.claude/skills/eng-phase ~/.agents/skills/
  cp -a ~/.claude/skills/eng-phase ~/.cursor/skills/
  cp -a ~/.claude/skills/eng-phase ~/.codex/skills/
  cp -a ~/.claude/skills/eng-phase ~/.config/opencode/skills/
fi

echo "\nInstalling loop-eng (Claude Code + Cursor + OpenCode, user home)"
npx --yes loop-eng install --tool claude-code --target "$HOME"
npx --yes loop-eng install --tool cursor --target "$HOME"
npx --yes loop-eng install --tool opencode --target "$HOME"
if [ -d ~/.claude/skills/loop-engineering ]; then
  mkdir -p ~/.agents/skills ~/.codex/skills ~/.config/opencode/skills
  cp -a ~/.claude/skills/loop-engineering ~/.agents/skills/
  cp -a ~/.claude/skills/loop-engineering ~/.codex/skills/
  cp -a ~/.claude/skills/loop-engineering ~/.config/opencode/skills/
fi

echo "\nInstalling caveman skill (Claude Code / Codex / Copilot / Cursor / etc.)"
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash

echo "\nInstalling graphify"
uv tool install graphifyy
graphify install --platform claude
graphify install --platform codex

echo "\nInstalling ai-memory"
zsh install-ai-memory.sh

echo "\nInstalling iTerm2 dynamic profile"
mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
cp iterm/dynamic-profile.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/felipefrizzo.json

sh setup-powerlevel10k.sh

compaudit | xargs chmod g-w,o-w