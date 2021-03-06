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

# apps
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
alias chromium="/Applications/Chromium.app/Contents/MacOS/Chromium"


# js

alias n="npm"
alias y="yarn"
alias nr="npm run"

# ruby

alias be="bundle exec"
alias ber="bundle exec rails"
alias berc="bundle exec rails c"
alias beg="bundle exec guard"

# Docker

alias dc='docker-compose'
alias dcb='docker-compose build'
alias dce='docker-compose exec'
alias dcps='docker-compose ps'
alias dct='docker-compose top'
alias dcrestart='docker-compose restart'
alias dcrm='docker-compose rm'
alias dcr='docker-compose run'
alias dcstop='docker-compose stop'
alias dcup='docker-compose up'
alias dcdn='docker-compose down'
alias dcl='docker-compose logs'
alias dclf='docker-compose logs -f'
alias dcpull='docker-compose pull'
alias dcstart='docker-compose start'

### Commnads ###

get_github_latest_release() {
   curl -s "https://api.github.com/repos/$1/$2/releases/latest" | jq -r ".assets[] | select(.name | test(\"$3\")) | .browser_download_url"
}