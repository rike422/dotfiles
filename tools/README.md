# tools

ツール管理ポリシー。

- `tools/scripts/`: リポジトリで保持する純粋スクリプト
- 生成可能なツール: `ops/install/setup-tools.sh` で `~/.local/bin` へ生成
- GitHub リリースバイナリ: `.chezmoiexternal.toml.tmpl` でバージョン固定して `~/.local/bin` へ展開

現在の生成対象:

- `gibo`

現在の external:

- `tokf`
- `sqz`
