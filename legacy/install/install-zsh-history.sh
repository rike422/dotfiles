DEST=$DOTFILES/pkg/history

rm -rf $DEST

git clone https://github.com/b4b4r07/history $DEST
cd $DEST 
source misc/zsh/init.zsh
