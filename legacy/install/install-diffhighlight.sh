###################
# intall diffhighlight
###################

DEST=$DOTFILES/pkg/diff-highlight
TMP_DIR=/tmp
cd $TMP_DIR
git clone https://github.com/git/git
cd git/contrib/diff-highlight
make
mv diff-highlight $DOTFILES/bin
rm -rf /tmp/git
