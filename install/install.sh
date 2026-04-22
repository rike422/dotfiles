#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cat <<EOF
[DEPRECATED] install/install.sh は廃止されました。

このリポジトリの適用経路は chezmoi のみです。
次のコマンドを実行してください:

  chezmoi apply --source "${REPO_ROOT}"

事前検証:
  "${REPO_ROOT}/scripts/verify-chezmoi.sh"
EOF

exit 1
