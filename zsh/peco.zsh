alias psp="ps aux | peco"
alias killp="ps aux | peco | awk '{print \$2}' | xargs kill -9"

zplug "rike422/27e0d0b07e9e81292067f81c4908587d", as:plugin, from:gist, use:peco_script.sh, hook-load:"
zle -N peco-select-history
bindkey '^R' peco-select-history

zle -N peco-find-file
bindkey '^f' peco-find-file
"
