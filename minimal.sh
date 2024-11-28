#
# Minimal settings and aliases for a comfortable bash experience
#
# Used by Monaco Digital admin team - version 20241128
#

# Minimal PATH
if [ "$EUID" -eq 0 ]; then
    PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin
else
    PATH=/usr/local/bin:/usr/bin
fi

# Exit if shell is not bash
[ -z "$BASH_VERSION" ] && exit

# Append to the history file, don't overwrite it
shopt -s histappend

# History expansion before executing the command
shopt -s histverify

# Disable the bloody terminal bell
bind 'set bell-style none'

# History expansion with the space key
bind 'Space: magic-space'

# Search through history with pgup/pgdown (sucks on laptops)
bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'

# Search through history with up/down arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# don't put duplicate lines or lines starting with space in the history
export HISTCONTROL=ignorespace:ignoredups

# Save the timestamp in the history, but don't output it by default
export HISTTIMEFORMAT=''

# Color stuff, if terminal supports it
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # Fix directory color (on some terminals blue on black is unreadable)
    # hash dircolors 2> /dev/null && eval $(dircolors -b | sed 's/di=01;34/di=01;35/')
    
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

# Show hostname and current directory in window title
export PROMPT_COMMAND='echo -ne "\e]0;${HOSTNAME%%.*}:${PWD}\a"'

# history aliases
hash h 2> /dev/null || alias h="history"
hash ht 2> /dev/null || alias ht="HISTTIMEFORMAT='%F_%T ' history"
hash hg 2> /dev/null || alias hg="history | grep"

# ls aliases
hash l 2> /dev/null || alias l='ls -lA'
hash ll 2> /dev/null || alias ll='ls -l'
hash llz 2> /dev/null || alias llz='ls -lA -Sr'
hash llt 2> /dev/null || alias llt='ls -lA -tr'
hash llg 2> /dev/null || alias llg='ls -lA | grep'

# journalctl aliases
hash j 2> /dev/null || alias j='journalctl -e'
hash je 2> /dev/null || alias je='journalctl -p err -e'

# ps aliases
hash psg 2> /dev/null || function psg { LANG=C ps -e -o user:20,pid,ppid,c,stime,tty,time,cmd | sed -n "1p; / $$ .* sed .* $$/d; /$1/p" ; }
