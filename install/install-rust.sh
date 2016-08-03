###################
# intall rust
# 安定してない
###################

DEST=$DOTFILES/pkg/rust
RUSTUP_HOME=$DEST

rm -rf $DEST
curl https://sh.rustup.rs -sSf | sh
eval $RUSTUP_HOME
