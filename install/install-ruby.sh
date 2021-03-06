###################
# intall ruby
###################

DOTFILES=$HOME/dotfiles

if [ $(uname) = "Linux" ]; then
	if uname -a | grep ubuntu -i >/dev/null; then
		#########
		# ubuntu
		#########
		sudo apt-get install -y \
			sqlite3 \
			libsqlite3-dev \
			mysql-client \
			libmysqlclient-dev
	fi
fi

DEST=$DOTFILES/pkg/rbenv

# change rbenv root to DEST
export RBENV_ROOT=$DEST
export CONFIGURE_OPTS="--disable-install-doc"

# install rbenv
rm -rf $DEST
git clone https://github.com/sstephenson/rbenv $DEST

# install ruby-build
mkdir -p $DEST/plugins
git clone https://github.com/sstephenson/ruby-build $DEST/plugins/ruby-build
git clone https://github.com/rbenv/rbenv-default-gems.git $DEST/plugins/rbenv-default-gems

# install rbenv default-gems
ln -s $DOTFILES/misc/rbenv/default-gems $DEST

$DEST/bin/rbenv install 2.6.2
$DEST/bin/rbenv global 2.6.2
