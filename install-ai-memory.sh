#!/bin/zsh
set -euo pipefail

# Idempotent. Re-runs keep the wiki in $AI_MEMORY_DATA_DIR.
# Requires Docker Desktop (Brewfile cask docker-desktop) and a running engine.

AI_MEMORY_HOME="${AI_MEMORY_HOME:-$HOME/.local/share/ai-memory}"
AI_MEMORY_DATA_DIR="${AI_MEMORY_DATA_DIR:-$AI_MEMORY_HOME/data}"
AI_MEMORY_NATIVE_BIN="${AI_MEMORY_NATIVE_BIN:-$AI_MEMORY_HOME/ai-memory}"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
WRAPPER_DST="$HOME/.local/bin/ai-memory"
RELEASE_BASE="https://github.com/akitaonrails/ai-memory/releases/latest/download"

printf "\nInstalling ai-memory (Docker server + host CLI + native hooks)\n"

mkdir -p "$AI_MEMORY_HOME" "$AI_MEMORY_DATA_DIR" "$HOME/.local/bin" \
  "$HOME/Library/Logs/ai-memory"

install_native_binary
cp "$REPO_DIR/ai-memory/docker-compose.yml" "$AI_MEMORY_HOME/docker-compose.yml"
wait_for_docker

install_wrapper() {
  local tmp expected actual
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  curl -fsSL "$RELEASE_BASE/ai-memory-wrapper" -o "$tmp/ai-memory-wrapper"
  curl -fsSL "$RELEASE_BASE/ai-memory-wrapper.sha256" -o "$tmp/ai-memory-wrapper.sha256"
  expected="$(awk 'NR == 1 { print $1 }' "$tmp/ai-memory-wrapper.sha256")"
  actual="$(shasum -a 256 "$tmp/ai-memory-wrapper" | awk '{ print $1 }')"
  if [ -z "$expected" ] || [ "$actual" != "$expected" ]; then
    echo "ai-memory wrapper checksum mismatch" >&2
    exit 1
  fi
  install -m 0755 "$tmp/ai-memory-wrapper" "$WRAPPER_DST"
  rm -rf "$tmp"
  trap - EXIT
}

install_native_binary() {
  local arch tarball tmp
  case "$(uname -m)" in
    arm64) arch="aarch64" ;;
    x86_64) arch="x86_64" ;;
    *)
      echo "unsupported uname -m $(uname -m); skip native binary (Docker wrapper hooks still work)" >&2
      return 0
      ;;
  esac
  tarball="ai-memory-macos-${arch}.tar.gz"
  tmp="$(mktemp -d)"
  curl -fsSL "$RELEASE_BASE/$tarball" -o "$tmp/$tarball"
  mkdir "$tmp/src"
  tar -xzf "$tmp/$tarball" -C "$tmp/src"
  if [ ! -x "$tmp/src/ai-memory" ]; then
    echo "native ai-memory binary missing from $tarball" >&2
    exit 1
  fi
  # Keep sibling hooks/ so install-hooks can find the bundle.
  # Never --delete: wiki is in data/, compose is copied from this repo.
  rsync -a --exclude data --exclude docker-compose.yml --exclude .env \
    "$tmp/src/" "$AI_MEMORY_HOME/"
  chmod 0755 "$AI_MEMORY_NATIVE_BIN"
  rm -rf "$tmp"
}

wait_for_docker() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "docker not on PATH; start Docker Desktop after brew cask install, then re-run $0" >&2
    exit 1
  fi
  if docker info >/dev/null 2>&1; then
    return 0
  fi
  echo "starting Docker Desktop..."
  open -a Docker
  local i
  for i in {1..90}; do
    if docker info >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done
  echo "docker engine did not become ready" >&2
  exit 1
}

wait_for_server() {
  local i code
  for i in {1..30}; do
    code="$(curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:49374/mcp || true)"
    if [ "$code" = "405" ]; then
      return 0
    fi
    sleep 1
  done
  echo "ai-memory server did not answer on 127.0.0.1:49374" >&2
  exit 1
}

install_wrapper
if [ -d /usr/local/bin ]; then
  ln -sfn "$WRAPPER_DST" /usr/local/bin/ai-memory 2>/dev/null || \
    sudo ln -sfn "$WRAPPER_DST" /usr/local/bin/ai-memory
fi

install_native_binary
wait_for_docker

export AI_MEMORY_HOME AI_MEMORY_DATA_DIR AI_MEMORY_NATIVE_BIN
export PATH="$HOME/.local/bin:$PATH"

docker compose -f "$AI_MEMORY_HOME/docker-compose.yml" --project-directory "$AI_MEMORY_HOME" pull
docker compose -f "$AI_MEMORY_HOME/docker-compose.yml" --project-directory "$AI_MEMORY_HOME" up -d
wait_for_server

HOOK_BIN="$AI_MEMORY_NATIVE_BIN"
if [ ! -x "$HOOK_BIN" ]; then
  HOOK_BIN="$WRAPPER_DST"
fi

# Native posix-native hooks when the extracted binary is present; wrapper fallback otherwise.
"$HOOK_BIN" --data-dir "$AI_MEMORY_DATA_DIR" install-mcp --client claude-code --apply
"$HOOK_BIN" --data-dir "$AI_MEMORY_DATA_DIR" install-hooks --agent claude-code --apply
"$HOOK_BIN" --data-dir "$AI_MEMORY_DATA_DIR" install-mcp --client codex --apply
"$HOOK_BIN" --data-dir "$AI_MEMORY_DATA_DIR" install-hooks --agent codex --apply

printf "ai-memory ready at http://127.0.0.1:49374\n"
printf "First Codex session: trust the new hooks in the TUI.\n"
printf "Optional LLM keys: %s/.env then ai-memory-restart\n" "$AI_MEMORY_HOME"
