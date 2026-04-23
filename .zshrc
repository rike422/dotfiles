#(d) is default on

# ------------------------------
# General Settings
# ------------------------------
export EDITOR=vim        # エディタをvimに設定
export LANG=ja_JP.UTF-8  # 文字コードをUTF-8に設定
export LC_TYPE=ja_JP.UTF-8
export KCODE=utf-8       # KCODEにUTF-8を設定
export AUTOFEATURE=true  # autotestでfeatureを動かす
export ZSH_CONFIG_DIR="$HOME/.config/zsh"

# bindkey -e             # キーバインドをemacsモードに設定
bindkey -v               # キーバインドをviモードに設定

bindkey -M viins '\er' history-incremental-pattern-search-forward
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^B' backward-char
bindkey -M viins '^D' delete-char-or-list
bindkey -M viins '^E' end-of-line
bindkey -M viins '^F' forward-char
bindkey -M viins '^G' send-break
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^K' kill-line
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^Y' yank

setopt no_beep           # ビープ音を鳴らさないようにする
setopt auto_cd           # ディレクトリ名の入力のみで移動する
setopt auto_pushd        # cd時にディレクトリスタックにpushdする
setopt correct           # コマンドのスペルを訂正する
setopt magic_equal_subst # =以降も補完する(--prefix=/usrなど)
setopt prompt_subst      # プロンプト定義内で変数置換やコマンド置換を扱う
setopt notify            # バックグラウンドジョブの状態変化を即時報告する
setopt equals            # =commandを`which command`と同じ処理にする

### Complement ###
autoload -U compinit; compinit # 補完機能を有効にする
setopt auto_list               # 補完候補を一覧で表示する(d)
setopt auto_menu               # 補完キー連打で補完候補を順に表示する(d)
setopt list_packed             # 補完候補をできるだけ詰めて表示する
setopt list_types              # 補完候補にファイルの種類も表示する
bindkey "^[[Z" reverse-menu-complete # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)

### Glob ###
setopt extended_glob # グロブ機能を拡張する
unsetopt caseglob    # ファイルグロブで大文字小文字を区別しない

### History ###
HISTFILE=~/.zsh_history # ヒストリを保存するファイル
HISTSIZE=10000          # メモリに保存されるヒストリの件数
SAVEHIST=10000          # 保存されるヒストリの件数
setopt bang_hist        # !を使ったヒストリ展開を行う(d)
setopt extended_history # ヒストリに実行時間も保存する
setopt hist_ignore_dups # 直前と同じコマンドはヒストリに追加しない
setopt share_history    # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存する

# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
autoload -Uz zmv

#autoload predict-on
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

## zplugの読み込み
export ZPLUG_HOME="$HOME/.zplug"
if [ -f "$ZPLUG_HOME/init.zsh" ]; then
  source "$ZPLUG_HOME/init.zsh"
  if ! zplug check; then
    echo "[WARN] zplug plugin 未導入です。必要時に 'zplug install' を実行してください。" >&2
  fi
else
  echo "[WARN] zplug が未初期化です。chezmoi apply で初期化してください。" >&2
fi

# ------------------------------
# Look And Feel Settings
# ------------------------------
### Ls Color ###
# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad
# 補完時の色の設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ZLS_COLORSとは？
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true

### Prompt ###
# プロンプトに色を付ける
autoload -U colors; colors
# 一般ユーザ時
tmp_prompt="%{${fg[cyan]}%}%n%# %{${reset_color}%}"
tmp_prompt2="%{${fg[cyan]}%}%_> %{${reset_color}%}"
tmp_rprompt="%{${fg[green]}%}[%~]%{${reset_color}%}"
tmp_sprompt="%{${fg[yellow]}%}%r is correct? [Yes, No, Abort, Edit]:%{${reset_color}%}"

# rootユーザ時(太字にし、アンダーバーをつける)
if [ ${UID} -eq 0 ]; then
  tmp_prompt="%B%U${tmp_prompt}%u%b"
  tmp_prompt2="%B%U${tmp_prompt2}%u%b"
  tmp_rprompt="%B%U${tmp_rprompt}%u%b"
  tmp_sprompt="%B%U${tmp_sprompt}%u%b"
fi

PROMPT=$tmp_prompt   # 通常のプロンプト
PROMPT2=$tmp_prompt2 # セカンダリのプロンプト(コマンドが2行以上の時に表示される)
RPROMPT=$tmp_rprompt # 右側のプロンプト
SPROMPT=$tmp_sprompt # スペル訂正用プロンプト
# SSHログイン時のプロンプト
if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
  PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
fi

### Title (user@hostname) ###
case "${TERM}" in
  kterm*|xterm*)
    precmd() {
      echo -ne "\033]0;${USER}@${HOST%%.*}\007"
    }
    ;;
esac

# ------------------------------
# Other Settings
# ------------------------------
# cheat-sheet
cheat-sheet() {
  local sheet="$ZSH_CONFIG_DIR/cheat-sheet.conf"
  [ -f "$sheet" ] && zle -M "$(cat "$sheet")"
}
zle -N cheat-sheet
bindkey "^[^h" cheat-sheet

# -----------------------------
# Ubuntu
# -----------------------------
if [ "$(uname)" = "Linux" ]; then
  [ -f "$ZSH_CONFIG_DIR/common_ubuntu.zsh" ] && source "$ZSH_CONFIG_DIR/common_ubuntu.zsh"

  if [ -s "$HOME/.xkb/keymap/mykbd" ]; then
    sleep 1
    xkbcomp -I"$HOME/.xkb" "$HOME/.xkb/keymap/mykbd" "$DISPLAY" 2>/dev/null
  fi
  export WINIT_UNIX_BACKEND=x11
fi

# -----------------------------
# includes
# -----------------------------
[ -f "$ZSH_CONFIG_DIR/plugins.zsh" ] && source "$ZSH_CONFIG_DIR/plugins.zsh"
[ -f "$ZSH_CONFIG_DIR/common.zsh" ] && source "$ZSH_CONFIG_DIR/common.zsh"
[ -f "$ZSH_CONFIG_DIR/auto_complete.zsh" ] && source "$ZSH_CONFIG_DIR/auto_complete.zsh"
[ -f "$ZSH_CONFIG_DIR/peco.zsh" ] && source "$ZSH_CONFIG_DIR/peco.zsh"
[ -f "$ZSH_CONFIG_DIR/prompt.zsh" ] && source "$ZSH_CONFIG_DIR/prompt.zsh"

# include localfile
[ -f "$ZSH_CONFIG_DIR/local.zsh" ] && source "$ZSH_CONFIG_DIR/local.zsh"
[ -f "$ZSH_CONFIG_DIR/alias.zsh" ] && source "$ZSH_CONFIG_DIR/alias.zsh"

if command -v zplug >/dev/null 2>&1; then
  zplug load --verbose
fi

# -----------------------------
# exports
# -----------------------------
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# zsh-completions
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

# rust
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

# runtime manager (mise-first)
if [ -x "$(command -v mise)" ]; then
  eval "$(mise activate zsh)"
elif [[ -o interactive ]]; then
  echo "[WARN] mise が見つかりません。ランタイムは有効化されません。" >&2
fi

# golang
export GOPATH="${GOPATH:-$HOME/dev}"
[ -d "$GOPATH/bin" ] && export PATH="$GOPATH/bin:$PATH"

# hub
if [ -x "$(command -v hub)" ]; then
  eval "$(hub alias -s)"
fi

# node
if [ -x "$(command -v npm)" ]; then
  . <(npm completion)
  alias npmls="npm ls --depth 0"
fi
export PATH="$HOME/node_modules/.bin:$PATH"
export PATH="./node_modules/.bin:$PATH"

if [ -x "$(command -v direnv)" ]; then
  eval "$(direnv hook zsh)"
fi

if [ -x "$(command -v docker)" ]; then
  export DOCKER_BUILDKIT=1
fi

# export bin
[ -d "$HOME/.local/openssl/bin" ] && export PATH="$HOME/.local/openssl/bin:$PATH"
[ -d "$HOME/.local/tmux/bin" ] && export PATH="$HOME/.local/tmux/bin:$PATH"
[ -d "$HOME/.local/peco" ] && export PATH="$HOME/.local/peco:$PATH"
