#!/bin/sh
echo ""
echo "Installing Terraform"
mkdir $HOME/terraform

# Download Terraform. URI: https://www.terraform.io/downloads.html
VERSION='0.9.4'
RELEASE='terraform_linux_amd64.zip'
curl -L 'https://releases.hashicorp.com/terraform/'$VERSION'/terraform_'$VERSION'_linux_amd64.zip' -o $HOME/terraform/$RELEASE
# Unzip and install
unzip $HOME/terraform/$RELEASE
