#(d) is default on

# ------------------------------
# General Settings
# ------------------------------
export EDITOR=vim        # エディタをvimに設定
export LANG=ja_JP.UTF-8  # 文字コードをUTF-8に設定
export KCODE=u           # KCODEにUTF-8を設定
export AUTOFEATURE=true  # autotestでfeatureを動かす

bindkey -e               # キーバインドをemacsモードに設定
#bindkey -v              # キーバインドをviモードに設定

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
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)

### Glob ###
setopt extended_glob # グロブ機能を拡張する
unsetopt caseglob    # ファイルグロブで大文字小文字を区別しない

### History ###
HISTFILE=~/.zsh_history   # ヒストリを保存するファイル
HISTSIZE=10000            # メモリに保存されるヒストリの件数
SAVEHIST=10000            # 保存されるヒストリの件数
setopt bang_hist          # !を使ったヒストリ展開を行う(d)
setopt extended_history   # ヒストリに実行時間も保存する
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存する

# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
autoload -Uz zmv

#autoload predict-on
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

export DOTFILES=$HOME/dotfiles

## zplugの読み込み
export ZPLUG_HOME=$DOTFILES/pkg/zplug
if [ -d "$DOTFILES/pkg/zplug" ]; then
  source $ZPLUG_HOME/init.zsh
  if ! zplug check; then
    zplug install
  fi
else
  $DOTFILES/install/install-zplug.sh
  zplug install
  source $HOME/.zshrc
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

PROMPT=$tmp_prompt    # 通常のプロンプト
PROMPT2=$tmp_prompt2  # セカンダリのプロンプト(コマンドが2行以上の時に表示される)
RPROMPT=$tmp_rprompt  # 右側のプロンプト
SPROMPT=$tmp_sprompt  # スペル訂正用プロンプト
# SSHログイン時のプロンプト
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
;

### Title (user@hostname) ###
case "${TERM}" in
  (kterm*|xterm*|)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}\007"
  }
  ;;
esac

# ------------------------------
# Other Settings
# ------------------------------
# cheat-sheet

cheat-sheet () { zle -M "`cat ~/zsh/cheat-sheet.conf`" }
zle -N cheat-sheet
bindkey "^[^h" cheat-sheet

# -----------------------------
# includes
# -----------------------------

[ -f $DOTFILES/zsh/plugins.zsh ] && source $DOTFILES/zsh/plugins.zsh
[ -f $DOTFILES/zsh/common.zsh ] && source $DOTFILES/zsh/common.zsh
[ -f $DOTFILES/zsh/auto_complete.zsh ] && source $DOTFILES/zsh/auto_complete.zsh
[ -f $DOTFILES/zsh/show_branch.zsh ] && source $DOTFILES/zsh/show_branch.zsh
[ -f $DOTFILES/zsh/peco.zsh ] && source $DOTFILES/zsh/peco.zsh

# include localfile
[ -f $DOTFILES/local/zsh/alias.zsh ] && source $DOTFILES/local/zsh/alias.zsh

zplug load --verbose
# -----------------------------
# exports
# -----------------------------

[ -d "$DOTFILES/bin" ] && export PATH=$DOTFILES/bin:$PATH

#zsh-completions
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

if [ -d "$DOTFILES/pkg/rust" ]; then
  source $HOME/.cargo/env
  source $HOME/.cargo/bin
fi

# golang
if [ -d "$DOTFILES/pkg/goenv/bin" ]; then
  export GOENV_ROOT="$DOTFILES/pkg/goenv"
  export GOROOT=$DOTFILES/pkg/goenv/current
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
fi

# rbenv
if [ -d "$DOTFILES/pkg/rbenv/bin" ]; then
  export CONFIGURE_OPTS="--disable-install-doc"
  export RBENV_ROOT=$DOTFILES/pkg/rbenv
  export PATH=$RBENV_ROOT/bin:$PATH
  eval "$(rbenv init -)"
  rbenv global 2.4.1
fi

# nodebrew
if [ -f $DOTFILES/pkg/nodebrew/nodebrew ]; then
  export NODEBREW_ROOT=$DOTFILES/pkg/nodebrew
  export PATH=$NODEBREW_ROOT/current/bin:$PATH
  # nodebrew use v6
  . <(npm completion)
  alias npmls="npm ls --depth 0"
  export PATH=$DOTFILES/node_modules/.bin:$PATH
  export PATH=./node_modules/.bin:$PATH
fi

# hub
if [ -d "$DOTFILES/pkg/hub/bin"  ]; then
  export PATH=$DOTFILES/pkg/hub/bin:$PATH
  eval "$(hub alias -s)"
fi

# Java-SDKMan
if [ -d "$DOTFILES/pkg/sdkman/bin"  ]; then
  export SDKMAN_DIR=$DOTFILES/pkg/sdkman
  source "${DOTFILES}/pkg/sdkman/bin/sdkman-init.sh"
fi
###
# exports (homebrew)
###
if [ `uname` = "Darwin" ]; then
  if [ -x "`echo $commands[postgres]`" ]; then
    export PGDATA=/usr/local/var/postgres
  fi
fi
