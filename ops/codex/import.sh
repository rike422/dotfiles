#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCE_CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
TARGET_CODEX_DIR="$ROOT_DIR/.codex"

log() {
  printf '[import-codex] %s\n' "$*"
}

if [ ! -d "$SOURCE_CODEX_DIR" ]; then
  echo "[ERROR] .codex directory が見つかりません: $SOURCE_CODEX_DIR" >&2
  exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
  echo "[ERROR] rsync が必要です。" >&2
  exit 1
fi

mkdir -p "$TARGET_CODEX_DIR"

entries=(
  "config.toml"
  "rules"
  "agents"
  "contexts"
  "commands"
  "skills"
)

for entry in "${entries[@]}"; do
  from="$SOURCE_CODEX_DIR/$entry"
  if [ -e "$from" ]; then
    log "import: $entry"
    rsync -a --delete "$from" "$TARGET_CODEX_DIR/"
  fi
done

cat > "$TARGET_CODEX_DIR/.chezmoiignore" <<'IGNORE'
*
!.chezmoiignore
!config.toml
!rules
!rules/**
!agents
!agents/**
!contexts
!contexts/**
!commands
!commands/**
!skills
!skills/**
IGNORE

log '.codex/.chezmoiignore を allowlist 方式で更新しました'
echo "[OK] .codex を取り込みました。差分を確認して commit してください。"
