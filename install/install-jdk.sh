DEST=$DOTFILES/pkg/sdkman

# change java sdkman root to DEST
export SDKMAN_DIR=$DEST

rm -rf $DEST
curl -s "https://get.sdkman.io" | bash

source "${DEST}/bin/sdkman-init.sh"
sdk install java
