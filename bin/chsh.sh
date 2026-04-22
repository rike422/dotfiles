#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

cat <<EOF
[DEPRECATED] bin/chsh.sh は廃止されました。

シェル変更を含む初期化は chezmoi 側で管理してください。
次のコマンドを実行してください:

  chezmoi apply --source "${REPO_ROOT}"
EOF

exit 1
