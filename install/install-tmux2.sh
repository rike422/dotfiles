cd $DOTFILES/pkg
wget https://github.com/tmux/tmux/releases/download/2.9/tmux-2.9.tar.gz
tar zxvf tmux-2.9.tar.gz
rm tmux-2.9.tar.gz
cd tmux-2.9
sh autogen.sh
./configure --prefix=$DOTFILES/local/tmux
make
make install
