# .bash_profile
source $HOME/.bash_prompt

# History Tweaks
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# colours!
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"
export LSCOLORS=GxFxCxDxBxegedabagaced

#completion's
if [ -f $(brew --prefix)/etc/bash_completion ]; then
   . $(brew --prefix)/etc/bash_completion
fi

# git prompt
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_SHOWSTASHSTATE=true

export EDITOR='open -a Atom.app'

export NVM_DIR=$HOME/.nvm
source $(brew --prefix nvm)/nvm.sh

export GOPATH=$HOME/Documents/workspaces/go/
export PATH=$PATH:$GOPATH/bin

export PYENV_ROOT=/usr/local/var/pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

export JAVA_HOME=$(/usr/libexec/java_home)

#alias
alias ll='ls -la'
alias ls='ls -a'
alias cd..='cd ..'
alias home='cd ~'
alias arquivos='cd /Volumes/Arquivos'
alias workspace='cd /Volumes/Arquivos/workspaces/'

alias gcma='git commit -am'
alias ga='git add .'
alias gp='git push'
alias gr='git rebase'

# Run source on bash_completion at the end of file to make sure process all alias
source $HOME/.bash_completion
