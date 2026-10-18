#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PROMPT_COMMAND=()

ls() { command ls --color=auto "$@"; }

grep() { command grep --color=auto "$@"; }
diff() { command diff --color=auto "$@"; }

PS1='\[\033]0;\h:$PWD\007\033[0;1;36m\]\h:$PWD \[\033[0;1;$(($??31:32))m\]\$ \[\033[0m\]'

[ -f ~/.bashrc.local ] && . ~/.bashrc.local

unalias -a
