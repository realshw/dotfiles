#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PROMPT_COMMAND=()

ls() { command ls --color=auto "$@"; }

grep() { command grep --color=auto "$@"; }
diff() { command diff --color=auto "$@"; }

PS1='\[\033]0;\h:$PWD\007\]\h:$PWD \$ '

[ -f ~/.bashrc.local ] && . ~/.bashrc.local

unalias -a
