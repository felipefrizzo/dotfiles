#!/bin/bash
echo ""
echo  "Installing RubyMine"

RELEASE='RubyMine'
VERSION='2017.2.1'

# Downloads
wget 'https://download.jetbrains.com/ruby/'$RELEASE'-'$VERSION'.tar.gz' -O $HOME'/'$RELEASE'-'$VERSION'.tar.gz'
tar -xvf $HOME'/'$RELEASE'-'$VERSION'.tar.gz'
