###################
# intall direnv
###################

if [ ! -d "$DOTFILES/pkg/goenv/bin" ]; then
	echo "先にgoのインストールを行ってください"。
	exit
fi
DEST=$DOTFILES/pkg/direnv

go get github.com/direnv/direnv
