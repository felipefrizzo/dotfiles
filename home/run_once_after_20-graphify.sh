#!/bin/zsh
set -eu

echo "\nInstalling graphify"
uv tool install graphifyy
graphify install --platform claude
graphify install --platform codex
