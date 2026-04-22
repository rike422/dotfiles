# dotfiles

このリポジトリは `chezmoi` を前提にした dotfiles source です。  
旧 `install/*` 導線は廃止し、`chezmoi apply --source <source>` に統一します。

## 運用方針

- 適用は常に `source` を明示します（`$HOME/dotfiles` への symlink 前提は廃止）。
- 初回セットアップは strict がデフォルトです（必須処理に失敗したら非0終了）。
- 非対話/権限制約環境でのみ `CHEZMOI_OPTIONAL_SETUP=1` を使って skip を許可します。
- optional-skip が発生した場合は完了マーカーを作らず、次回 `chezmoi apply` で再試行します。
- zsh 拡張は `~/.config/zsh` 配下へ寄せる方針です。`zsh/` ディレクトリは現時点で apply 対象外のレガシー資材として扱います。

## セットアップ

```bash
# 推奨: chezmoi 未導入なら自動導入して apply
./scripts/bootstrap-chezmoi.sh --source "$(pwd)"

# source を環境変数で指定
CHEZMOI_SOURCE_DIR=/path/to/dotfiles ./scripts/bootstrap-chezmoi.sh

# chezmoi バージョン固定（任意）
CHEZMOI_VERSION=v2.63.0 ./scripts/bootstrap-chezmoi.sh --source "$(pwd)"

# installer のチェックサム検証（任意）
CHEZMOI_INSTALLER_SHA256=<sha256> ./scripts/bootstrap-chezmoi.sh --source "$(pwd)"
```

`bootstrap-chezmoi.sh` は以下を実行します。

1. `chezmoi` がなければ `~/.local/bin` にインストール
2. 指定 source で `chezmoi apply` 実行

`DOTFILES` symlink は作成・更新しません。

## strict / optional

`.chezmoiscripts`（`run_before_*`）は strict がデフォルトです。  
成功時は `~/.local/state/chezmoi-bootstrap/*.done` に完了マーカーを書きます。

- strict（既定）: `sudo` 不可、非対話で `chsh` 不可、必須コマンド不足などで失敗
- optional: `CHEZMOI_OPTIONAL_SETUP=1` のときのみ上記を skip 成功扱い（マーカーは未作成）
- Homebrew installer の検証を有効化する場合は `HOMEBREW_INSTALLER_SHA256` を設定

例:

```bash
# strict
./scripts/bootstrap-chezmoi.sh --source "$(pwd)"

# optional（CI/自動化向け）
CHEZMOI_OPTIONAL_SETUP=1 ./scripts/bootstrap-chezmoi.sh --source "$(pwd)"
```

## Codex 設定取り込み

```bash
./scripts/import-codex.sh
git status
```

`import-codex.sh` は `~/.codex` から次のみ取り込みます。

- `config.toml`
- `rules/`
- `agents/`
- `contexts/`
- `commands/`
- `skills/`

`.codex/.chezmoiignore` は allowlist 方式で生成され、上記以外は apply 対象外です。

## 検証

```bash
# doctor + apply dry-run
./scripts/verify-chezmoi.sh "$(pwd)"
```

## CI 方針

`.travis.yml` は旧 `install/install.sh` を使いません。  
CIは非対話制約のため optional モード検証を実施し、以下を実行します。

1. シェルスクリプト / zsh 設定の構文検証
2. `CHEZMOI_OPTIONAL_SETUP=1` で `bootstrap-chezmoi.sh --dry-run`
3. `verify-chezmoi.sh` で doctor + dry-run
