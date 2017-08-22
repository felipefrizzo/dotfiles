#!/bin/bash
echo ""
echo  "Installing NVM"

VERSION='v0.33.2'
curl -o- 'https://raw.githubusercontent.com/creationix/nvm/'$VERSION'/install.sh' | bash
