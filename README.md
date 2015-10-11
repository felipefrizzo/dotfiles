Felipe Frizzo's dotfiles.
This repository include all of my custom dotfiles.

This include the following step.

* install xcode-cli
* install homebrew
* install all applications from homebrew
* install atom plugins
* install external softwares
* run set OsX system defaults
* run set user defaults
* copy bash configurations to home user folder
* install latest updates from app store
* configure Dock with the applications

Installation

Download
```
mkdir dotfiles
cd dotfiles
curl -#L http://github.com/felipefrizzo/dotfiles/tarball/master | tar -xvz --strip-components 1
chmod +x *.sh
sh setup.sh
cd ..
rm -rf dotfiles
```
