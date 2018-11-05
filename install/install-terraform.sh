DOTFILES=$HOME/dotfiles
DEST=$DOTFILES/local/bin
TERRA_FORM_VERSION=0.11.10
ZIP_NAME=terraform_${TERRA_FORM_VERSION}_darwin_amd64.zip
wget https://releases.hashicorp.com/terraform/$TERRA_FORM_VERSION/$ZIP_NAME -P /tmp/
unzip /tmp/$ZIP_NAME -d $DEST