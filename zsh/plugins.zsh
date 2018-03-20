# 補完キーワード強化
zplug "zsh-users/zsh-completions"
zplug "plugins/aws", from:oh-my-zsh
zplug "plugins/gitfast", from:oh-my-zsh
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh


# 絵文字
zplug "mrowa44/emojify", as:command
zplug "b4b4r07/emoji-cli"

# zsh-syntax-highlight
zplug "zsh-users/zsh-syntax-highlighting", defer:2, hook-load: "ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'"
zplug "b4b4r07/zsh-vimode-visual", defer:3

# インタラクティブフィルタ
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux

# ゴミ箱
zplug "b4b4r07/zsh-gomi", if:"which fzf"

# 移動
zplug "b4b4r07/enhancd", use:init.sh
zplug "b4b4r07/zsh-vimode-visual"

# myplguin
zplug "rike422/git-tmp"
zplug "rike422/git-wip", if: "which hub"

# git
zplug "rimraf/k"

# shell commands (specify export directory path using `of` specifier)
zplug "b4b4r07/http_code", as:command, use:bin
