TMP_DIR=/tmp/protobuf-rules-gen
TMP_FILE=/tmp/protobuf-rules-gen
DEST=$DOTFILES/local/bin/protobuf-rules-gen

if [ $(uname) = "Linux" ]; then
	PLATFORM='linux-x86_64'
	$DOTFILES/bin/github_latest_release.sh firebase protobuf-rules-gen $PLATFORM | xargs wget -O $TMP_FILE
	unzip -d $TMP_FILE -d $TMP_DIR
	mv $TMP_DIR/bin/protobuf-rules-gen $DEST
else
	PLATFORM='osx-x86_64'
	$DOTFILES/bin/github_latest_release.sh firebase protobuf-rules-gen $PLATFORM | xargs wget -O $TMP_FILE
	unzip $TMP_FILE -d $TMP_DIR
	mv $TMP_DIR/bin/protobuf-rules-gen $DEST
fi

echo "Install $(which protobuf-rules-gen)"
rm $TMP_FILE
rm -rf $TMP_DIR
