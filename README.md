# Felipe Frizzo's dotfiles for Linux.
This repository include all of my custom dotfiles.

This include the following step.

* install apt packeges
* install all applications
* install atom plugins
* install external softwares
* copy bash configurations to home user folder
* install latest updates

### Installation

Download
```shell
mkdir dotfiles
cd dotfiles
curl -#L http://github.com/felipefrizzo/dotfiles/tarball/linux/ubuntu | tar -xvz --strip-components 1
chmod +x *.sh
sh setup.sh
cd ..
rm -rf dotfiles
```
