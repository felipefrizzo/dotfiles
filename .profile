export EDITOR="code"

export GOPATH="$HOME/Documents/workspaces/go/"
export PATH="$GOPATH/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

if type brew &>/dev/null; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh"

  export PATH="$(brew --prefix openssl@1.1)/bin:$PATH"
  export PATH="$(brew --prefix sqlite3)/bin:$PATH"

  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

  . "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  . "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export JAVA_HOME=$(/usr/libexec/java_home)

. "$HOME/.aliases"
. "$HOME/.switch_version"
eval "$(jump shell)"
