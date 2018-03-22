TMP_DIR=/tmp/protobuf
TMP_FILE=/tmp/protobuf.zip
DEST=$DOTFILES/pkg/protobuf

if [ `uname` = "Linux" ]; then
    PLATFORM='linux-x86_64'
    $DOTFILES/bin/github_latest_release.sh google protobuf $PLATFORM | xargs wget -O $TMP_FILE
    unzip -d $TMP_FILE -d $TMP_DIR
    mv $TMP_DIR/bin/protoc $DEST 
else
    PLATFORM='osx-x86_64'
    $DOTFILES/bin/github_latest_release.sh google protobuf $PLATFORM | xargs wget -O $TMP_FILE
    unzip $TMP_FILE -d $TMP_DIR
    mv $TMP_DIR/bin/protoc $DEST 
fi

echo "Install `which protoc`"
rm $TMP_FILE
rm -rf $TMP_DIR