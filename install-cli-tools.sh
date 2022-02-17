echo ""
echo "Installing latest CLI Tools…"
xcode-select --install

echo ""
echo "Software Update..."
softwareupdate -ia --verbose

if [[ $(uname -m) == 'arm64' ]]; then
  echo ""
  echo "Installing Roseta..."
  sudo softwareupdate --install-rosetta
fi 