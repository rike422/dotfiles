### Aliases ###
alias -g N="1>/dev/null 2>/dev/null" # No Output
alias -g B="1>/dev/null 2>/dev/null &" # Back
alias -g C="2>&1 | color" # Color
alias -g H="| xxd -g 1 -c 4" # Hex
alias -g V="2>&1 | vim -c "au! CursorHold" -" # open stdout with vim
alias -g U="| sort | uniq -c | sort -nr"

alias tree="tree --charset unicode -L 3"
alias re="exec $SHELL"
alias be="bundle exec"
alias nr="npm run"

alias rmf="\rm -rf"
alias cdd="cd $DOTFILES"
alias cddb="cd $DOTFILES/bin"
alias cddi="cd $DOTFILES/install"

alias ll="ls -ah"
alias lls="ls -a"

alias pry="nocorrect pry"
alias diff="colordiff"
alias less="less -R"
alias npn="npm-popute"

### Commnads ###

# current time
function now() {
  UNIXTIME=$(curl -s "http://www.convert-unix-time.com/api?timestamp=now&timezone=tokyo" | jq .timestamp)
  date -r $UNIXTIME +%Y/%m/%d\(%a\)\ %H:%M
}
