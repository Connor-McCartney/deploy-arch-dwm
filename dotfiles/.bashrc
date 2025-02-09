# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#normal/default green, directories aqua underlined, executables pink, .py red
export LS_COLORS="no=32:di=4;96:ex=1;35:*.py=1;31"
export PS1="\[\e[0;35m\]\n[\w]\[\[\e[m\] \[\e[0;37m\]\n\$\[\e[m\] "

alias t="cd ~/t"
alias dt="rm -rf ~/t/*"
alias v=nvim
alias ls="ls --color=auto"
alias l=ls
alias p="/home/connor/.p/bin/python"
alias pip="/home/connor/.p/bin/pip"

sage() {
    command sage $1 && rm "${1}.py"
}
alias s=sage

cd() {
        command cd $1 && printf $(pwd) > /tmp/lastdir
}

c() {
  cd "$1" && ls
}


fzf() {
	command fzf --bind "ctrl-o:down,tab:accept"
}

V() {
	cd
	export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
	nvim $(fzf --preview="bat --color=always {}");
}

C() {
	cd;
	export FZF_DEFAULT_COMMAND="fd --type d --strip-cwd-prefix --hidden --follow --exclude .git"
	cd $(fzf)
}

[[ "$PWD" == "/home/connor" ]] && cd t
