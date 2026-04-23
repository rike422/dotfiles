# dotfiles

このリポジトリは `chezmoi` source です。
互換運用は切り、用途ごとにディレクトリを分離しています。

## ディレクトリ構成

- `.`（ルート）: chezmoi で配布する dotfiles 本体（`.zshrc` など）
- `.config/zsh/`: 運用中の zsh 拡張設定
- `.chezmoiscripts/`: 初回セットアップ用 `run_before_*`
- `tools/scripts/`: 保持する純粋スクリプト（セットアップ時に `~/.local/bin` へリンク）
- `.codex/`: Codex 設定の管理対象（allowlist）
- `ops/chezmoi/`: chezmoi 運用スクリプト（bootstrap/verify）
- `ops/codex/`: Codex 設定取り込みスクリプト
- `ops/install/`: 生成可能ツールのセットアップスクリプト

## セットアップ

```bash
# 推奨: chezmoi 未導入なら自動導入して apply
./ops/chezmoi/bootstrap.sh --source "$(pwd)"

# source を環境変数で指定
CHEZMOI_SOURCE_DIR=/path/to/dotfiles ./ops/chezmoi/bootstrap.sh

# chezmoi バージョン固定（任意）
CHEZMOI_VERSION=v2.63.0 ./ops/chezmoi/bootstrap.sh --source "$(pwd)"

# installer のチェックサム検証（任意）
CHEZMOI_INSTALLER_SHA256=<sha256> ./ops/chezmoi/bootstrap.sh --source "$(pwd)"
```

初期セットアップ時に以下を自動実施します。

- `tools/scripts/*` の純粋スクリプトを `~/.local/bin` にリンク
- 生成可能なツール（`gibo`）を `~/.local/bin` へ生成

`ops/install/setup-tools.sh` は単体でも再実行できます。

```bash
./ops/install/setup-tools.sh --source "$(pwd)"
```

## strict / optional

`.chezmoiscripts`（`run_before_*`）は strict が既定です。

- strict: 必須処理に失敗したら非0終了
- optional: `CHEZMOI_OPTIONAL_SETUP=1` のときのみ skip 許可

`optional` で skip が発生した場合、
`~/.local/state/chezmoi-bootstrap/*.done` の完了マーカーは作成されません。
次回 `chezmoi apply` で再試行されます。

```bash
# strict
./ops/chezmoi/bootstrap.sh --source "$(pwd)"

# optional（CI/自動化向け）
CHEZMOI_OPTIONAL_SETUP=1 ./ops/chezmoi/bootstrap.sh --source "$(pwd)"
```

## Codex 設定の取り込み

```bash
./ops/codex/import.sh
git status
```

`.codex/.chezmoiignore` は allowlist 管理です。
対象は `config.toml`, `rules/`, `agents/`, `contexts/`, `commands/`, `skills/` のみです。

## 検証

```bash
./ops/chezmoi/verify.sh "$(pwd)"
```

## CI

GitHub Actions（`.github/workflows/ci.yml`）で以下を実行します。

1. シェル/ zsh 構文検証
2. `CHEZMOI_OPTIONAL_SETUP=1` で `bootstrap --dry-run`
3. `verify` で doctor + dry-run
