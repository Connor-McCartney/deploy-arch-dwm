# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#normal/default green, directories aqua underlined, executables pink, .py red
export LS_COLORS="no=32:di=4;96:ex=1;35:*.py=1;31"
export PS1="\[\e[0;35m\]\n[\w]\[\[\e[m\] \[\e[0;37m\]\n\$\[\e[m\] "

alias n="nasm -f elf64 x.asm && ld x.o && ./a.out"
alias q="qemu-system-x86_64"
alias t="cd ~/t"
alias dt="rm -rf ~/t/*"
alias v=nvim
alias vv="sudo nvim"
alias ls="ls --color=auto"
alias l=ls
alias la="l -lash"
alias p="/home/connor/.p/bin/python"
alias pip="/home/connor/.p/bin/pip"
alias m="sudo make clean install"
alias untar="tar -xvzf" # or just use ut
alias sc="printf \"\033[?25h\"" # show cursor

sage() {
    command sage $1 && rm "${1}.py"
}
alias s=sage
alias xx="nvim x.sage"
alias x="sage x.sage"

cx() {
  chmod +x "$1"
}

cd() {
    command cd $1
    [[ "$PWD" != "/home/connor/t" ]] && printf $(pwd) > /tmp/lastdir
}

c() {
  cd "$1" && ls
}

fzf() {
    command fzf --bind "ctrl-o:down,tab:accept" --preview="bat --color=always {}"
}

V() {
    cd
    export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
    d=$(fzf)
    nvim "$HOME/${d}";
    cd "${d%/*}" # nice trick, ${var%SubStr*}  # drops substring from last occurrence of `SubStr` to end of string
}

C() {
    cd
    export FZF_DEFAULT_COMMAND="fd --type d --strip-cwd-prefix --hidden --follow --exclude .git"
    cd $(/bin/fzf --bind "ctrl-o:down,tab:accept")
}
[[ "$PWD" == "/home/connor" ]] && cd t
