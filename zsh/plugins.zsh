# 補完キーワード強化
zplug "zsh-users/zsh-completions"

# 絵文字
zplug "mrowa44/emojify", as:command

# インタラクティブフィルタ
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux

# ゴミ箱
zplug "b4b4r07/zsh-gomi", if:"which fzf"
