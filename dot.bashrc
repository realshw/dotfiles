#
# ~/.bashrc - user-specific configuration loaded for interactive bash shells.
#
# Every section below configures some aspect of the shell; the comment above
# each one explains what it does and why.
#

# Stop here for non-interactive shells (when bash is running a script); none
# of the interactive-only behaviour configured below applies in that case.
[[ $- != *i* ]] && return

# If the user has enabled `errexit`, re-sourcing this file could abort at the
# first failing command.  Switch it off so the file can always be sourced
# again cleanly.
shopt -u -o errexit

# After every external command finishes, re-read the terminal's size so that
# line wrapping stays correct when the window is resized.
shopt -s checkwinsize

# Only offer tab-completion once something has actually been typed.
shopt -s no_empty_cmd_completion

# ---------------------------------------------------------------------------
# Command history
#
# Controls how past commands are recorded and displayed.
# ---------------------------------------------------------------------------
# Add each session's new commands to the existing ~/.bash_history instead of
# replacing it, so commands from previous sessions are never lost on exit.
shopt -s histappend

HISTSIZE=10000                       # commands kept in the current session
HISTFILESIZE=20000                   # commands kept in ~/.bash_history
HISTCONTROL='ignoredups:ignorespace' # ignore repeats and space-prefixed lines
HISTTIMEFORMAT='%F %T  '             # date/time shown beside `history` output

# ---------------------------------------------------------------------------
# Window title
#
# On terminals that support it (xterm, screen, tmux) keep the title bar in
# sync with the prompt: hostname followed by the full working directory, with
# the username omitted.
# ---------------------------------------------------------------------------
PROMPT_COMMAND=()
if [[ $TERM =~ xterm|screen|tmux ]]; then
	PROMPT_COMMAND+=('printf "\033]0;%s:%s\007" "$HOSTNAME" "$PWD"')
fi

# ---------------------------------------------------------------------------
# Colour-aware command wrappers
#
# `ls`, `grep` and `diff` are wrapped so their output is coloured.  They are
# defined as functions rather than aliases so they survive the `unalias -a`
# below, and --color=auto is used so output is coloured only when it reaches
# a terminal (never when piped to a file or another command).
# ---------------------------------------------------------------------------
function ls   { command ls   --color=auto "$@"; }
function grep { command grep --color=auto "$@"; }
function diff { command diff --color=auto "$@"; }

# Drop every alias that may already be defined; the colour-aware functions
# above take over the commands we care about.
unalias -a

# ---------------------------------------------------------------------------
# Tab completion
#
# Load the system-wide programmable completion rules when the machine provides
# them, giving context-aware completions for many commands.
# ---------------------------------------------------------------------------
if [[ -r /usr/share/bash-completion/bash_completion ]]; then
	. /usr/share/bash-completion/bash_completion
fi

# ---------------------------------------------------------------------------
# Prompt
#
#   host:/full/path [ exitstatus ]$
#
# The username is deliberately omitted so the working directory can always be
# shown in full, never collapsed to `~` (which would be ambiguous across
# users).  The previous command's exit status is coloured bold green when it
# was 0 (success) and bold red otherwise.
# ---------------------------------------------------------------------------
PS1='\[\e[0;1m\]\h:$PWD [ \[\e[0;1;$(($??31:32))m\]$?\[\e[0;1m\] ]\$\[\e[0m\] '

# Fall back to a minimal prompt when the terminal is too narrow for the full
# one shown above.
if ((0 < COLUMNS && COLUMNS < 80)); then
	PS1='\[\e[0;1;$(($??31:32))m\]\$\[\e[0m\] '
fi

# ---------------------------------------------------------------------------
# Local, machine-specific customisation
#
# ~/.bashrc.local is not tracked by the shared dotfiles repository, so it is
# the right place for tweaks that should apply on this machine only.  Source
# it here if it is present.
# ---------------------------------------------------------------------------
[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local

# Finish with a successful status so that sourcing this file never leaks a
# non-zero result into the environment (which could otherwise happen when
# ~/.bashrc.local is absent).
true
