# .bashrc

#region Startup
if [[ -z $TERM ]] ; then
    return 0 # Not a terminal - BAILOUT
fi

# Download git-completion if it's not installed
if [[ ! -f ${HOME}/.git-completion.sh ]] ; then
    echo "Downloading .git-completion.sh..."
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ${HOME}/.git-completion.sh
fi
#endregion

#region Source other scripts
source_files=(
    /etc/bashrc
    ${HOME}/.bashrc_secret
    ${HOME}/.git-completion.sh
    ${HOME}/.iterm2_shell_integration.bash
    ${HOME}/.travis/travis.sh
    /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
    /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash
)

for file in ${source_files[@]} ; do
    echo "Sourcing ${file}..."
    if [[ -f ${file} ]] ; then
        source "${file}"
    else
        echo "WARNING: ${file} not found"
    fi
done
#endregion

#region Bash/Terminal Settings
set -o vi
stty -ixon # Prevent Ctrl-S from freezing terminal
#endregion

#region Variables
# System Environment Variables
export EDITOR='vim'
export GPG_TTY=$(tty)
export HISTIGNORE='*clear-line'
export LS_COLORS=${LS_COLORS}:'di=0;34:ex=0;32:fi=0;37:ow=0;34:'
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/git/share/man/git-manpages:${PATH}"  # Add coreutils and git to MANPATH
export PATH="${PATH}:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${HOME}/bin"  # Add ~/bin/ to PATH
export PATH="/usr/local/opt/coreutils/libexec/gnubin:${HOME}/Developer/bin:${PATH}"
export VISUAL='vim'

# Custom Environment Variables
export CD_TRACKING=true # If true, will track last directory cd'ed
export LONG_PWD=false # If true, show long pwd

# Colors (W/ escapes for PS1)
RED="\[\e[0;31m\]"
GREEN="\[\e[0;32m\]"
YELLOW="\[\e[0;33m\]"
BLUE="\[\e[0;34m\]"
BOLD="\[\e[01;34m\]"
GRAY="\[\e[01;32m\]"
COLOROFF="\[\e[0;m\]"

# Colors (No escapes)
NO_WRAP_RED="\e[0;31m"
NO_WRAP_GREEN="\e[0;32m"
NO_WRAP_YELLOW="\e[0;33m"
NO_WRAP_BLUE="\e[0;34m"
NO_WRAP_BOLD="\e[01;34m"
NO_WRAP_GRAY="\e[01;32m"
NO_WRAP_COLOROFF="\e[0;m"
#endregion

#region Bindings
bind '"\e[21~":"toggle-cd-tracking;clear-line\n"' # Bind F10 to toggle-cd-tracking
bind '"\e[23~":"toggle-long-pwd;clear-line\n"' # Bind F11 to toggle-long-pwd
bind '"\e[24~":"fg\n"' # Bind F12 to fg
#endregion

#region Aliases
alias clear-line='printf "\033[1A\033[K"'
alias cls='cs'
alias create-virtualenv='python3 -m virtualenv .venv'
alias ct="date '+%Y%m%d%H%M%S'"
alias dir='ll'
alias generate-password='diceware -d " " -c -n 4'
alias ll='ls -lah --color --group-directories-first'
alias lx='xterm > /dev/null 2>&1 &'
alias root='sudo su -'
alias scratch="vim ${HOME}/Documents/scratch"
alias todo="vim ${HOME}/Documents/todo.txt"
alias venv='source ./.venv/bin/activate'
alias workspace='tmux new -s workspace'
#endregion

#region Functions
cat() {
    [[ $# -eq 1 ]] && /bin/cat "$1"
    [[ $# -gt 1 ]] && for i in $@ ; do printf "\n==> ${i} <==\n" ; /bin/cat "$i" ; printf "\n" ; done
}

# Log last directory accessed for login redirect
function cd() {
    builtin cd "$*"
    [[ ${CD_TRACKING} == true ]] && pwd > ~/.lastdir
}

# Clear screen and print todo list
cs() { /usr/bin/clear ; print-todo ; }

# Kill and remove all docker containers
cleanhouse() {
    docker kill $(docker ps -q) 2> /dev/null
    docker rm $(docker ps -a -q) 2> /dev/null
}

# For PS1; Get git branch name and style it depending on clean/dirty status
get_git() {
    local branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/")
    if [[ $branch != "" ]] ; then # If in git directory
        if [[ $(git status) != *'nothing to commit'* ]] ; then # Dirty directory
            local gitstat="${YELLOW}(${branch}*)${COLOROFF} "
        else # Clean directory
            local gitstat="${GREEN}(${branch})${COLOROFF} "
        fi
    fi
    printf "${gitstat}"
}

# Remove all local git branches
git-cleanup-branches() { git branch | grep -v "master" | xargs git branch -D ; }

# Print todo list from ~/Docuemnets/todo.txt
print-todo() {
    if [[ $(cat ~/Documents/todo.txt | wc -l | tr -d ' ') -gt 0 ]] ; then
        printf "${NO_WRAP_RED}TODO:\n${NO_WRAP_COLOROFF}"
        while read line; do
            printf "${NO_WRAP_RED} + ${NO_WRAP_COLOROFF}${line}\n"
        done < "${HOME}/Documents/todo.txt"
    fi
}

# Save .url file to ~/Documents/Bookmarks
save-bookmark() {
  [[ ! -d ${HOME}/Documents/Bookmarks ]] && mkdir "${HOME}/Documents/Bookmarks"
  [[ $# -ne 2 ]] && printf "Usage: save-bookmark \"Bookmark Name\" \"https://url.com\"\n"
  [[ $# -eq 2 ]] && printf "[InternetShortcut]\nURL=${2}\n\n" > "${HOME}/Documents/Bookmarks/${1}.url"
}

# Toggle CD tracking for new shells
toggle-cd-tracking() {
  if [[ ${CD_TRACKING} == false ]] ; then
      builtin cd $(cat ~/.lastdir)
      export CD_TRACKING=true
  else
      export CD_TRACKING=false
  fi
}

# Toggle long PWD in prompt
toggle-long-pwd() {
  if [[ ${LONG_PWD} == false ]] ; then
      export LONG_PWD=true
  else
      export LONG_PWD=false
  fi
}

trash() { mv $@ ${HOME}/.trash ; }
#endregion

#region Prompt 
# Based off this: https://gist.github.com/henrik/31631
function git_prompt {
    [[ -n ${VIRTUAL_ENV} ]] && local pyenv="(${VIRTUAL_ENV##*/}) "
    local gitstat="$(get_git)"
    [[ ${LONG_PWD} == true ]] && local _pwd="\w"
    [[ ${LONG_PWD} == false ]] && local _pwd="\W"
    [[ ${CD_TRACKING} == false ]] && local tracker=" 🕵 "
    [[ $(tput cols) -gt 90 ]] && local end="${BOLD} $ ${COLOROFF}"
    [[ $(tput cols) -lt 90 ]] && local end="\n${BOLD}$ ${COLOROFF}"
    PS1="${pyenv}${gitstat}${GRAY}\u@\h:${BLUE}${_pwd}${tracker}${end}"
}
PROMPT_COMMAND="git_prompt"
#endregion

#region Initialize
# Welcome Message/Startup Functions
/usr/bin/clear # Clear out login shit
printf "${NO_WRAP_BLUE}Welcome!${NO_WRAP_COLOROFF}\n"
printf "Redirecting to $(cat ~/.lastdir)\n"
cd $(cat ~/.lastdir) # Redirect to the last directory before logout

# Print TODO list
print-todo
#endregion
