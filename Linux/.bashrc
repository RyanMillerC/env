# .bashrc

if [[ -z $TERM ]] ; then
    return 0 # Not a terminal - BAILOUT
fi

# Source extra junk
for file in /etc/bashrc ${HOME}/.bashrc_secret ; do
    if [[ -f ${file} ]] ; then
        source "${file}"
    fi
done

set -o vi 

# Environment Variables
export EDITOR='vim'
export LS_COLORS=${LS_COLORS}:'di=0;34:ex=0;32:fi=0;37:'
export PATH="${PATH}:${HOME}/bin" # Add ~/bin/ to PATH
export VISUAL='vim'

# COLORS
RED="\[\e[0;31m\]"
GREEN="\[\e[0;32m\]"
YELLOW="\[\e[0;33m\]"
BLUE="\[\e[0;34m\]"
BOLD="\[\e[01;34m\]"
GRAY="\[\e[01;32m\]"
COLOROFF="\[\e[0;m\]"

# (Key) Bindings
bind '"\e[24~":"fg\n"' # Bind the fg command to F12

# Aliases
alias atom='atom --force-device-scale-factor=1.25'
alias ll='ls -lah --color --group-directories-first'
alias lx='xterm > /dev/null 2>&1 &'
#alias python='python3'
#alias pip='pip3'
alias root='sudo su -'
alias scratch="vim ${HOME}/Documents/scratch"

# Functions
u2f_aws() {
    xclip -in <(ykman oath code AWS | cut -d' ' -f 2)
}
cat() {
    [[ $# -eq 1 ]] && /bin/cat "$1"
    [[ $# -gt 1 ]] && for i in $@ ; do printf "\n==> ${i} <==\n" ; /bin/cat "$i" ; printf "\n" ; done
}
function cd() { # Log last directory accessed for login redirect
    builtin cd "$*"
    pwd > ~/.lastdir
}
cleanhouse() {
    docker kill $(docker ps -q) 2> /dev/null
    docker rm $(docker ps -a -q) 2> /dev/null
}
ct() { date '+%Y%m%d%H%M%S' ; }
spoof_traffic() {
    sudo sysctl net.ipv4.ip_default_ttl=65
    echo 65 | sudo tee /proc/sys/net/ipv4/ip_default_ttl
    printf "\e[0;31mGo forth and do good things...\e[0m\n"
}
trash() { mv $@ ${HOME}/.trash ; }

get_git() {
    local branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/")
    if [[ $branch != "" ]] ; then # If in git directory
        if [[ $(git status) != *'nothing to commit'* ]] ; then # Dirty directory
            local gitstat="${YELLOW}(${branch}*) "
        else # Clean directory
            local gitstat="${GREEN}(${branch}) "
        fi
    fi
    printf "${gitstat}"
}

# Prompt - Based off this: https://gist.github.com/henrik/31631
function git_prompt {
    local pyenv=${VIRTUAL_ENV:+(}${VIRTUAL_ENV##*/}${VIRTUAL_ENV:+) }
    local ps1="${GRAY}\u@\h:${BLUE}\W"
    local gitstat=$(get_git)
    local end="${BOLD} $ ${COLOROFF}"
    PS1="${gitstat}${pyenv}${ps1}${end}" # Prompt up to the git branch
}
PROMPT_COMMAND="git_prompt"

# Welcome Message/Startup Functions
clear # Clear out login shit
printf "\e[0;34mThinkPad\e[0m\n"
printf "Redirecting to $(cat ~/.lastdir)\n"
cd $(cat ~/.lastdir) # Redirect to the last directory before logout

