# Upstream supply-chain review

このディレクトリは **第三者 CLI のソース差分** です。`.chezmoidata.yaml` のバージョン数字だけ見ても悪意は分かりません。

やってほしいこと:
1. 各 `{name}.diff` を読む（truncated なら Compare URL も見る）
2. 新規ネットワーク、認証情報、install-time スクリプト、難読化、デフォルト権限の拡大を探す
3. 最後に `merge` / `merge with notes` / `do not merge` をツールごとに出す

heuristic ヒットは手がかりであり、自動拒否ではありません。

### tokf v0.2.52 → v0.2.53
- Compare: https://github.com/mpecan/tokf/compare/tokf-v0.2.52...tokf-v0.2.53
- commits: 11, files: 79
- diff: `tokf.diff`
- files: `tokf.files.md`

特記なし

