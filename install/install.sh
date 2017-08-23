
###################
# common
###################
echo "alias ls='ls -la --col'" >> ~/.bashrc

export DOTFILES=`dirname $0`/..
echo DOTFILES=$DOTFILES



###################
# distoribute
###################
if [ `uname` = "Linux" ]; then
  if uname -a | grep ubuntu -i >/dev/null; then

    # for git 2.7
    #sudo -E apt-get install python-software-properties
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:git-core/ppa
    sudo apt-get install git

    #########
    # ubuntu
    #########
    sudo apt-get update
    sudo apt-get install -y \
    build-essential \
    cmake \
    coreutils \
    libssl-dev \
    libreadline6-dev \
    libncurses5-dev \
    libxml2-dev \
    libxslt1-dev \
    libpcre3 \
    libpcre3-dev \
    libev4 \
    libev-dev \
    libevent-dev \
    tree \
    xsel \
    vim-gnome \
    git-core \
    zsh \
    jq \
    w3m \
    curl \
    ngrep\
    unzip \
    apcalc \
    source-highlight \
    ctags \
    zopfli \
    git \
    tig \
    nkf

  else
    #########
    # cent
    #########

    # JST time
    sudo cp /usr/share/zoneinfo/Japan /etc/localtime
    # package for build
    sudo yum install -y git gcc-c++ openssl-devel make
  fi
elif [ `uname` = "Darwin" ]; then
  # install gibo
  $DOTFILES/install/ruby.sh
  # install homebrew
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  # install homebrew-cask
  brew tap caskroom/cask

  brew install \
  tmux \
  tree \
  zsh \
  git \
  tig \
  vim \
  rmtrash \
  wget \
  nkf \
  ngrep \
  ssh-copy-id \
  reattach-to-user-namespace \
  jq \
  pt \
  w3m \
  calc \
  source-highlight \
  alfred \
  ctags \
  mas \
  zopfli

  # auth
  brew cask install \
  authy-desktop \

  # utility
  brew cask install \
  dropbox \
  alfred \
  skype \
  google-drive \
  licecap \

  # dev tools
  brew cask install \
  iterm2 \
  virtualbox \
  vagrant \
  intellij-idea \
  atom \
  sketch

  # browsers
  brew cask install \
  firefox \
  google-chrome \
  vivaldi

  # Change default PATH order in mac for homebrew
  if ! diff /etc/paths $DOTFILES/misc/mac.paths >/dev/null ; then
    sudo mv /etc/paths /etc/paths.orig
    sudo cp $DOTFILES/misc/mac.paths /etc/paths
  fi

  # install application from app store
  $DOTFILES/install/install-appstore.sh
fi

# install tmux v2
$DOTFILES/install/install-tmux2.sh
# install gibo
$DOTFILES/install/zplug.sh

# link dotfiles to home
$DOTFILES/bin/slink.sh

# chsh to zsh
$DOTFILES/bin/chsh.sh
