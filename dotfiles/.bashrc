alias em="emacs -nw"
alias ll="ls -l"
alias k="cd ../.."

alias s36="ssh -Y -l jeff shalgo36"

export EDITOR="emacs -nw"
export LESS="-XR"

# Fix up & down arrow
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Exit before doing pretty prompt (which breaks non-interactive)
[ -z "$PS1" ] && return

# Pretty prompt
export PS1="\[\e[0;33m\][\u@\h:\w]\$ \[\e[m\]"

