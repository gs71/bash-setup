#
# Minimal settings and aliases for a comfortable bash experience
#
# Used by Monaco Digital team - version 20241105
#

# Append to the history file, don't overwrite it
shopt -s histappend

# History expansion before executing the command
shopt -s histverify

# History expansion with the space key
bind 'Space: magic-space'

# Search through history with up/down arrows (default pgup/pgdn sucks on laptops)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# don't put duplicate lines or lines starting with space in the history
export HISTCONTROL=ignorespace:ignoredups

# Save the timestamp in the history, but don't output it by default
export HISTTIMEFORMAT=''

# Color stuff, if terminal supports it
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # Fix directory color (on some terminals blue on black is unreadable)
    export LS_COLORS='di=1;35'

    # Colored prompt, to differentiate it from command output
    if [ "$UID" = "0" ]; then
        # Red prompt for root
        PS1='\[\e[01;31m\]\u@\h\[\e[00m\]:\[\e[01;33m\]$PWD\[\e[00m\]\$ '
    else
        # Green prompt for regular user
        PS1='\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;33m\]$PWD\[\e[00m\]\$ '
    fi

    # Colored grep and ls
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias ls='ls --color=auto'
fi

# Minimal PATH
if [ "$UID" = "0" ]; then
    PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin
else
    PATH=/usr/local/bin:/usr/bin
fi

# Show hostname and current directory in window title
export PROMPT_COMMAND='echo -ne "\e]0;${HOSTNAME%%.*}:${PWD}\a"'

# history aliases
type h > /dev/null 2>&1 || alias h="history"
type ht > /dev/null 2>&1 || alias ht="HISTTIMEFORMAT='%F_%T ' history"
type hg > /dev/null 2>&1 || alias hg="history | grep"

# ls aliases
type l > /dev/null 2>&1 || alias l='ls -lA'
type ll > /dev/null 2>&1 || alias ll='ls -l'
type llz > /dev/null 2>&1 || alias llz='ls -lA -Sr'
type llt > /dev/null 2>&1 || alias llt='ls -lA -tr'
type llg > /dev/null 2>&1 || alias llg='ls -lA | grep'

# Quick grep for process
type psg > /dev/null 2>&1 || function psg { LANG=C ps -e -o user:20,pid,ppid,c,stime,tty,time,cmd | sed -n "1p; / $$ .* sed .* $$/d; /$1/p" ; }
