# 補完キーワード強化
zplug "zsh-users/zsh-completions"

# 絵文字
zplug "mrowa44/emojify", as:command
zplug "b4b4r07/emoji-cli"

# zsh-syntax-highlight
zplug "zsh-users/zsh-syntax-highlighting", nice:10, hook-load: "ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'"

# インタラクティブフィルタ
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux

# ゴミ箱
zplug "b4b4r07/zsh-gomi", if:"which fzf"

# 移動
zplug "b4b4r07/enhancd", use:init.sh

# myplguin
zplug "rike422/git-tmp"
zplug "rike422/git-wip", if: "which hub"

# git
zplug "rimraf/k"

# shell commands (specify export directory path using `of` specifier)
zplug "b4b4r07/http_code", as:command, of:bin
