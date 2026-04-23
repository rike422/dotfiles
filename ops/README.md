# ops

運用スクリプト群。

- `ops/chezmoi/bootstrap.sh`: chezmoi 導入 + apply
- `ops/chezmoi/verify.sh`: doctor + apply dry-run
- `ops/codex/import.sh`: `~/.codex` 取り込み
- `ops/install/setup-mise.sh`: mise 導入
- `ops/install/setup-mise-tools.sh`: mise runtime/tool 導入
- `ops/install/setup-tools.sh`: 純粋スクリプトのリンク + 生成可能ツールの作成

## runtime 管理方針（mise-first）

- 言語ランタイム導入・切替は `mise` に統一
- `ops/install/setup-mise.sh` が runtime manager の導入責務を持つ
- `ops/install/setup-mise-tools.sh` が runtime/tool の導入責務を持つ
- ランタイム有効化は `.zshrc` の `eval "$(mise activate zsh)"` で実施

## レガシー導線の吸収先

| 旧カテゴリ | 新しい責務 |
| --- | --- |
| `rbenv` / `goenv` / `nodebrew` / `phpenv` / `sdkman` / `evm` | `mise` に集約 |
| 個別 install スクリプト運用 | `ops/chezmoi/bootstrap.sh` + `run_before_25/35` へ集約 |
| ツール配布（runtime 以外） | `ops/install/setup-tools.sh` |
