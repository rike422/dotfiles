### Aliases ###
alias -g N="1>/dev/null 2>/dev/null" # No Output
alias -g B="1>/dev/null 2>/dev/null &" # Back
alias -g C="2>&1 | color" # Color
alias -g H="| xxd -g 1 -c 4" # Hex
alias -g V="2>&1 | vim -c "au! CursorHold" -" # open stdout with vim
alias -g U="| sort | uniq -c | sort -nr"

alias vi="vim"
alias t="tig"

alias tree="tree --charset unicode -L 3"
alias re="exec $SHELL"

alias rmf="\rm -rf"
alias cdd="cd $DOTFILES"
alias cddb="cd $DOTFILES/bin"
alias cddi="cd $DOTFILES/install"

alias zmv='noglob zmv -W'

alias ll="ls -ah"
alias lls="ls -a"

alias pry="nocorrect pry"
alias diff="colordiff"
alias less="less -R"
alias npn="npm-popute"

alias g='git'
alias md='cd $(ghq root)/$(ghq list | peco)'
alias gho='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'

# js

alias npm="n"
alias yarn="y"
alias nr="npm run"

# ruby

alias be="bundle exec"
alias ber="bundle exec rails"
alias berc="bundle exec rails c"
alias beg="bundle exec guard"

### Commnads ###
