#!/bin/zsh
set -eu

echo "\nInstalling mise-managed toolchains (node/python/go/java)"
eval "$(/opt/homebrew/bin/brew shellenv)"
mise install
