#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cat <<EOF
[DEPRECATED] bin/slink.sh は廃止されました。

シンボリックリンク作成は chezmoi が管理します。
次のコマンドを実行してください:

  chezmoi apply --source "${REPO_ROOT}"
EOF

exit 1
