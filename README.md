# dotfiles

このリポジトリは `chezmoi` source です。
互換運用は切り、用途ごとにディレクトリを分離しています。

## ディレクトリ構成

- `dot_*`（ルート）: chezmoi source。`dot_zshrc` は `~/.zshrc` に展開される
- `dot_config/zsh/`: 運用中の zsh 拡張設定（`~/.config/zsh/`）
- `dot_config/mise/`: mise グローバル設定（`~/.config/mise/`）
- `.chezmoiscripts/`: 初回セットアップ用 `run_before_*`
- `tools/scripts/`: 保持する純粋スクリプト（セットアップ時に `~/.local/bin` へリンク）
- `dot_codex/`: Codex 設定の管理対象（`~/.codex/`、allowlist）
- `ops/chezmoi/`: chezmoi 運用スクリプト（bootstrap/verify）
- `ops/codex/`: Codex 設定取り込みスクリプト
- `ops/install/`: セットアップスクリプト（mise導入 / runtime導入 / 純粋スクリプトリンク）

## セットアップ

```bash
# 推奨: chezmoi 未導入なら自動導入して apply
./ops/chezmoi/bootstrap.sh --source "$(pwd)"

# source を環境変数で指定
CHEZMOI_SOURCE_DIR=/path/to/dotfiles ./ops/chezmoi/bootstrap.sh

# chezmoi バージョン固定（任意）
CHEZMOI_VERSION=v2.72.0 ./ops/chezmoi/bootstrap.sh --source "$(pwd)"

# installer のチェックサム検証（任意）
CHEZMOI_INSTALLER_SHA256=<sha256> ./ops/chezmoi/bootstrap.sh --source "$(pwd)"
```

初期セットアップ時に以下を自動実施します。

- `run_before_25_install_mise.sh.tmpl`: mise 導入
- `tools/scripts/*` の純粋スクリプトを `~/.local/bin` にリンク
- 生成可能なツール（`gibo`）を `~/.local/bin` へ生成
- `run_before_35_setup_mise_tools.sh.tmpl`: runtime/tool 導入（mise）

必要なら個別に再実行できます。

```bash
# mise 導入
./ops/install/setup-mise.sh --source "$(pwd)"

# mise runtime/tool 導入
./ops/install/setup-mise-tools.sh --source "$(pwd)"

# 純粋スクリプトリンク + gibo 生成
./ops/install/setup-tools.sh --source "$(pwd)"
```

## ランタイム管理（mise-first）

- `.zshenv` は `eval "$(mise activate zsh --shims)"` で非対話シェルにもランタイムを通します
- `.zshrc` は `eval "$(mise activate zsh)"` で対話シェルの hook を有効化します
- 言語ランタイム導入・バージョン固定は `mise` 側で実施します
- `mise` 未導入時は `.zshrc` が concise な warning を出し、シェル自体は継続します

## レガシーカテゴリからの対応表

| レガシーカテゴリ | 旧方式 | 新フロー |
| --- | --- | --- |
| Java | `sdkman` | `mise` で一元管理（zsh 起動時に `mise activate`） |
| Erlang/Elixir | `evm` | `mise` で一元管理（zsh 起動時に `mise activate`） |
| Go | `goenv` | `mise` で一元管理 + `.zshenv` で `GOPATH/bin` を補助 |
| Ruby | `rbenv` | `mise` で一元管理 |
| PHP | `phpenv` | `mise` で一元管理 |
| Node.js | `nodebrew` | `mise` で一元管理 + npm 補完/`npmls` は `.zshrc`、`node_modules/.bin` は `.zshenv` |
| `aws-cli`/`hub`/`direnv`/`protoc`/`peco` | 個別 install スクリプト | `run_before_35_setup_mise_tools.sh.tmpl` で `mise install` |
| `gibo`/`diff-highlight`/`color` など | `bin/` 直配置 | `tools/scripts/` 保持 + `run_before_30_setup_tools.sh.tmpl` でリンク |
| インストール導線 | 個別 runtime install スクリプト | `ops/chezmoi/bootstrap.sh`（`run_before_*`）+ `mise` + `ops/install/*` |

旧 runtime-manager 前提の初期化・インストール責務は `mise` + `chezmoi` フローに吸収しています。

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

`dot_codex/.chezmoiignore` は allowlist 管理です。
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
