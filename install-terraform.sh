#!/bin/sh
echo ""
echo "Installing Terraform"
mkdir $HOME/terraform

# Download Terraform. URI: https://www.terraform.io/downloads.html
VERSION='0.10.2'
RELEASE='terraform_linux_amd64.zip'
wget 'https://releases.hashicorp.com/terraform/'$VERSION'/terraform_'$VERSION'_linux_amd64.zip?_ga=2.267933449.605624787.1503400238-989872445.1503400238' -O $HOME/terraform/$RELEASE
# Unzip and install
unzip $HOME/terraform/$RELEASE
