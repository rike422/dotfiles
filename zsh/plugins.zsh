# 補完キーワード強化
zplug "zsh-users/zsh-completions"

# 絵文字
zplug "mrowa44/emojify", as:command

#シンタックスハイライト
zplug "zsh-users/zsh-syntax-highlighting", nice:10

# インタラクティブフィルタ
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux

# ゴミ箱
zplug "b4b4r07/zsh-gomi", if:"which fzf"

# 移動
zplug "b4b4r07/enhancd", use:init.sh

# myplguin
zplug "rike422/git-atm"
