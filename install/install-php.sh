###################
# intall ruby
###################

DOTFILES=$HOME/dotfiles

DEST=$DOTFILES/pkg/phpenv

# change rbenv root to DEST
export RBENV_ROOT=$DEST
export CONFIGURE_OPTS="--disable-install-doc"

# install rbenv
rm -rf $DEST
git clone git://github.com/phpenv/phpenv.git $DEST

# install ruby-build
mkdir -p $DEST/plugins
git clone https://github.com/php-build/php-build $DEST/plugins/php-build

# install rbenv default-gems
ln -s $DOTFILES/misc/rbenv/default-gems $DEST

$DEST/bin/phpenv install 7.2
$DEST/bin/phpenv global 7.2