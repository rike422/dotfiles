###################
# intall rust
# 安定してない
###################

DEST=$DOTFILES/pkg/rust
RUSTUP_HOME=$DEST
TMP_RUSTUP=$RUSTUP_HOME/rustup.sh

rm -rf $DEST
mkdir $DEST
curl https://sh.rustup.rs -sSf >$TMP_RUSTUP
chmod +x $TMP_RUSTUP
eval $TMP_RUSTUP -y --no-modify-path
