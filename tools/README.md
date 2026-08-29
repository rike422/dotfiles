# tools

ツール管理ポリシー。

- `tools/scripts/`: リポジトリで保持する純粋スクリプト
- 生成可能なツール: `ops/install/setup-tools.sh` で `~/.local/bin` へ生成
- GitHub リリースバイナリ: `.chezmoidata.yaml` でバージョン固定し、`.chezmoiexternal.toml.tmpl` で `~/.local/bin` へ展開
- 更新確認: `tools/scripts/check-externals`
- 更新 PR: `.github/workflows/update-externals.yml`（手動 / 月曜定期）。自動マージしない
- 上流 diff: 更新 PR の `ops/externals/review/` をエージェントに読ませる。ピン変更だけでは本体コードは見えない

現在の生成対象:

- `gibo`

現在の external:

- `tokf`
- `sqz`
