# ------------------------------
# Environment Variables and PATH
# .zshenv is always sourced for all shells (interactive, non-interactive, scripts)
# ------------------------------

export ZSHENV_LOADED=1

# Homebrew (macOS)
if [ "$(uname)" = "Darwin" ]; then
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Local bins
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Rust
if [ -f "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

# mise shims for non-interactive shells
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh --shims)"
fi

# golang
export GOPATH="${GOPATH:-$HOME/dev}"
[ -d "$GOPATH/bin" ] && export PATH="$GOPATH/bin:$PATH"

export PATH="$HOME/node_modules/.bin:$PATH"
export PATH="./node_modules/.bin:$PATH"

[ -d "$HOME/.local/openssl/bin" ] && export PATH="$HOME/.local/openssl/bin:$PATH"
[ -d "$HOME/.local/tmux/bin" ] && export PATH="$HOME/.local/tmux/bin:$PATH"
[ -d "$HOME/.local/peco" ] && export PATH="$HOME/.local/peco:$PATH"
