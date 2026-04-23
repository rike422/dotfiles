#!/usr/bin/env bash
set -euo pipefail

if ! command -v chezmoi >/dev/null 2>&1; then
  echo "[ERROR] chezmoi が見つかりません。https://www.chezmoi.io/install/ を参照してください。" >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
SOURCE_DIR="${1:-$ROOT_DIR}"
DEST_DIR="$(mktemp -d /tmp/chezmoi-dest.XXXXXX)"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "[ERROR] source directory が存在しません: $SOURCE_DIR" >&2
  exit 1
fi

echo "[INFO] source: $SOURCE_DIR"
echo "[INFO] destination(dry-run): $DEST_DIR"

chezmoi doctor --source "$SOURCE_DIR" --destination "$DEST_DIR"
chezmoi apply --dry-run --source "$SOURCE_DIR" --destination "$DEST_DIR" --verbose

echo "[OK] dry-run が成功しました。"
