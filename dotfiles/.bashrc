# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#normal/default green, directories aqua underlined, executables pink, .py orange
export LS_COLORS="no=32:di=4;96:ex=1;35:*.py=1;31"
export PS1="\[\e[0;35m\]\n[\w]\[\[\e[m\] \[\e[0;37m\]\n\$\[\e[m\] "

alias t="cd ~/t"
alias dt="rm -rf ~/t/*"
alias h=helix
alias ls="ls --color=auto"
alias l=ls

c() {
  cd "$1" && ls
}

# launch tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi
