#!/bin/zsh
set -eu

echo ""
echo "Installing latest CLI Tools…"
xcode-select --install

echo ""
echo "Software Update..."
softwareupdate -ia --verbose

if [[ $(uname -m) == 'arm64' ]]; then
  echo ""
  echo "Installing Rosetta..."
  sudo softwareupdate --install-rosetta
fi
