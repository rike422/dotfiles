autoload -Uz colors; colors
autoload -Uz add-zsh-hook
autoload -Uz terminfo

terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
left_down_prompt_preexec() {
    print -rn -- $terminfo[el]
}

add-zsh-hook preexec left_down_prompt_preexec

function branch-status-check {
  local prefix branchname suffix
  # .gitの中だから除外
  if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
    return
  fi
  branchname=`get-branch-name`
  # ブランチ名が無いので除外
  if [[ -z $branchname ]]; then
    echo "%{${fg[cyan]}%}_(:3 ｣ ∠ )_%{${reset_color}%}"
    return
  fi
  prefix=`get-branch-status` #色だけ返ってくる
  suffix='%{'${reset_color}'%}'

  echo "${prefix}_(${branchname})_${suffix} >"
}

function get-branch-name {
  # gitディレクトリじゃない場合のエラーは捨てます
  echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}

function get-branch-status {
  local res color
  output=`git status 2> /dev/null`
  if [[ -n `echo $output | grep "^nothing to commit"` ]]; then
    res=':' # status Clean
    color='%{'${fg[green]}'%}'
  elif [[ -n `echo $output | grep "^# Untracked files:"` ]]; then
    res='?:' # Untracked
    color='%{'${fg[yellow]}'%}'
  elif [[ -n `echo $output | grep "^# Changes not staged for commit:"` ]]; then
    res='M:' # Modified
    color='%{'${fg[red]}'%}'
  else
    res='A:' # Added to commit
    color='%{'${fg[cyan]}'%}'
  fi
  # echo ${color}${res}'%{'${reset_color}'%}'
  echo ${color} # 色だけ返す
}

function zle-keymap-select zle-line-init zle-line-finish
{
    case $KEYMAP in
        main|viins)
            PROMPT_2="$fg[cyan]-- INSERT --$reset_color"
            ;;
        vicmd)
            PROMPT_2="$fg[white]-- NORMAL --$reset_color"
            ;;
        vivis|vivli)
            PROMPT_2="$fg[yellow]-- VISUAL --$reset_color"
            ;;
    esac

    PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}`branch-status-check`#> "
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line