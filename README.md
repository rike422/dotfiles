# dotfiles

このリポジトリは `chezmoi` source として利用できます。
既存の dotfiles と `~/.codex`（rules/agents/skills など）を同じリポジトリで管理する想定です。

## 1. 初回セットアップ

```bash
# chezmoi インストール
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin

# この repo を source として dry-run
./scripts/verify-chezmoi.sh

# 実適用
chezmoi apply --source "$HOME/dotfiles"
```

## 2. 管理対象

`.chezmoiignore` で適用対象を限定しています。

- 管理する: 主要 dotfiles（`.zshrc`, `.gitconfig`, `.tmux.conf` など）
- 管理する: `.codex/**`（必要に応じて追加）
- 除外する: `install/`, `bin/`, `pkg/`, `local/`, `misc/`, `zsh/` などの運用資材

## 3. Codex 設定/Skill の取り込み

```bash
# ~/.codex からリポジトリ配下 .codex へ取り込み
./scripts/import-codex.sh

# 差分確認
git status
```

`import-codex.sh` は以下のみを取り込みます。

- `config.toml`
- `rules/`
- `agents/`
- `contexts/`
- `commands/`
- `skills/`

`plugins/cache/` は `.codex/.chezmoiignore` で除外します。

## 4. テスト方法

```bash
# chezmoi の前提チェック + apply dry-run
./scripts/verify-chezmoi.sh

# 任意の source を指定して検証
./scripts/verify-chezmoi.sh /path/to/source
```

この dry-run が通れば、`chezmoi apply --source <source>` の適用前検証として利用できます。

## 5. 既存インストーラ

従来の `install/install.sh` も残しています。
段階移行のため、`chezmoi` と併用可能です。
