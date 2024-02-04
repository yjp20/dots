alias cf="~/.go/bin/cf-tool"

alias g="git"
alias gs="git status"
alias gco="git checkout"
alias gcm="git commit"
alias gcma="git commit --amend --no-verify"
alias gp="g++ --std=c++17 -g -fsanitize=address -fsanitize=undefined"

alias s="pushd ~/school/23"
alias ss="pushd ~/school"
alias c="pushd ~/competitions"
alias cv="pushd ~/cv"
alias p="pushd ~/projects"
alias w="pushd ~/work"
alias stl="sh -c 'cd ~/work && pnpm \$@' sh"

rg() {
	if [ -f ".gitignore" ]; then
		 IGNORE_FILE="--ignore-file .gitignore"
	else
		 IGNORE_FILE=""
	fi

	rg -uuu $IGNORE_FILE -g '!.git/'
}

vim() {
	echo hi
  if command -v nvim > /dev/null 2>&1; then
    nvim "$@"
  elif command -v vim > /dev/null 2>&1; then
    /usr/bin/vim "$@"
  else
    return 1
  fi
}

pd () {
	FILE=$1
	shift
	pandoc -d ~/sync/dot/template/pandoc.yaml --highlight-style ~/sync/dot/template/hi.theme --filter pandoc-include "${FILE}" -o "${FILE}.pdf" $@
}

