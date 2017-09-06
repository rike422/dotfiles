###################
# intall evm
###################

DEST=$DOTFILES/pkg/evm
export EVM_HOME=$DOTFILES/pkg/evm
rm -rf $DEST
git clone https://github.com/rike422/evm.git $DEST
$DEST/install
source $DEST/scripts/evm
