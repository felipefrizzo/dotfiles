# .bash_profile
source .bash_prompt

# History Tweaks
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# colours!
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"
export LSCOLORS=GxFxCxDxBxegedabagaced

# completion's
if [ -f $(brew --prefix)/etc/bash_completion ]; then
   . $(brew --prefix)/etc/bash_completion
fi

# env
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# git prompt
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_SHOWSTASHSTATE=true

export EDITOR='open -a /Applications/Atom.app'

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home/

# alias
alias ll='ls -la'
alias cd..='cd ..'
alias home='cd ~'
alias arquivos='cd /Volumes/Arquivos'

alias gitf=git-flow
