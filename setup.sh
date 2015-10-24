echo "\nSetup OsX"

sh install-cli-tools.sh
sh install-homebrew.sh
sh install-atom-plugins.sh
sh install external-software.sh

sudo sh osx-system-defaults.sh
sh osx-user-defaults.sh

cp .bash_prompt ~/
cp .bash_profile ~/
cp .inputrc ~/
cp .gitconfig ~/
cp .gitignore_global ~/

echo "\nSoftware Update"
softwareupdate -iva

echo "\nSetup app's on dock"
python setup-dock.py
