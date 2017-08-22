#!/bin/bash
echo ""
echo  "Installing PyCharm"

RELEASE='pycharm-professional'
VERSION='2017.2.1'

# Downloads
wget 'https://download.jetbrains.com/python/'$RELEASE'-'$VERSION'.tar.gz' -O $HOME'/'$RELEASE'-'$VERSION'.tar.gz'
tar -xvf $HOME'/'$RELEASE'-'$VERSION'.tar.gz'
