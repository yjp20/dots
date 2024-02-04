#!/bin/zsh

mkdir -p ~/.config

if [ $SHELL != "/bin/fish" ]; then
	if read -q '?Change shell to fish? (y/n) '; then
		echo
		chsh -s /bin/fish
	else
		echo
	fi
fi

link() {
	local source="$1"
	local target="$2"

	if [ ! -e "$target" ]; then
		mkdir -p "$(dirname "$target")"
		ln -fs "$source" "$target"
		echo "✅ Symbolic link created: $target -> $source"
	else
		echo "⚠️  Warning: Target file already exists. No symbolic link created: $target"
	fi
}

if read -q '?Install dotfile symlinks? (y/n) '; then
	echo
	if [ -f ~/sync/dot ]; then
		ln -fs ~/sync/dot ~
	fi

	link ~/dot/linux/user-dirs.dirs ~/.config/user-dirs.dirs
	link ~/dot/linux/dircolors      ~/.dircolors

	link ~/dot/vim/vimrc        ~/.vimrc
	link ~/dot/zsh/zshrc        ~/.zshrc
	link ~/dot/tmux/tmux.conf   ~/.tmux.conf
	link ~/dot/kitty/kitty.conf ~/.config/kitty/kitty.conf
	link ~/dot/helix            ~/.config/helix
	link ~/dot/nvim             ~/.config/nvim
else
	echo
fi

if read -q '?Install vim-plug? (y/n) '; then
	echo
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim -u NONE +PlugInstall +qall
else
	echo
fi

