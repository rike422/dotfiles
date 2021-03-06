###################
# intall goenv
###################

DOTFILES=$HOME/dotfiles
DEST=$DOTFILES/pkg/goenv
GOENV_ROOT=$DOTFILES/pkg/goenv
rm -rf $DEST
git clone https://github.com/kaneshin/goenv.git $DEST

$GOENV_ROOT/bin/goenv install 1.12
$GOENV_ROOT/bin/goenv global 1.12
eval "$(goenv init -)"
