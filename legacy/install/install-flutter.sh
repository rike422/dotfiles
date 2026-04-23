###################
# intall flutter
# https://flutter.io/setup-macos/
###################

DEST=$DOTFILES/pkg/flutter
git clone -b beta https://github.com/flutter/flutter.git $DEST

$DEST/bin/flutter doctor
