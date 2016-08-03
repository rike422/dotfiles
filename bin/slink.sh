dotfiles=".vimrc .vim .ideavimrc .gemrc .gitconfig .gitignore_global .zshrc .tmux.conf .hgrc .npmrc .tigrc .pryrc"
for dotfile in $dotfiles
do
  ln -s "$HOME/dotfiles/$dotfile" $HOME
done
