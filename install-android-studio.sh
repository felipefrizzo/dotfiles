#!/bin/bash
echo ""
echo  "Installing Android Studio"

VERSION='2.3.3.0' \
RELEASE='android-studio-ide' \
RELEASE_VERSION='162.4069837' \

# Downloads
wget 'https://dl.google.com/dl/android/studio/ide-zips/'$VERSION'/'$RELEASE'-'$RELEASE_VERSION'-linux.zip' -O $HOME'/'$RELEASE'-'$RELEASE_VERSION'.zip'
unzip $HOME'/'$RELEASE'-'$RELEASE_VERSION'.zip'
