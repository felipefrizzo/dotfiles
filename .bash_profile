# .bash_profile
source $HOME/.bash_prompt
source $HOME/.aliases

# History Tweaks
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# colours!
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"
export LSCOLORS=GxFxCxDxBxegedabagaced

# git prompt
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_SHOWSTASHSTATE=true

export EDITOR='open -a Atom.app'

if [ -d $HOME/.nvm ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
fi

export GOPATH=$HOME/workspaces/go/
export PATH=$PATH:$GOPATH/bin

if [ -d $HOME/.pyenv ]; then
  export PATH=$PATH:$HOME/.pyenv/bin
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

if [ -d $HOME/.rbenv ]; then
  export PATH="$PATH:$HOME/.rbenv/bin"
  export PATH="$PATH:$HOME/.rbenv/plugins/ruby-build/bin"
  eval "$(rbenv init -)"
elif [ -d $HOME/.rvm ]; then
  export PATH="$PATH:$HOME/.rvm/bin"
fi

export PATH=$PATH:/home/felipefrizzo/terraform
export JAVA_HOME="/usr/lib/jvm/java-8-oracle"

# Run source on bash_completion at the end of file to make sure process all alias
source $HOME/.bash_completion
