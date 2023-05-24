# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  1password
  ansible
  aws
  branch
  brew
  bundler
  celery
  common-aliases
  cp
  docker
  docker-compose
  dotenv
  gcloud
  gem
  git
  git-extras
  git-flow
  gitignore
  golang
  helm
  heroku
  history
  httpie
  iterm2
  jira
  kops
  kubectl
  macos
  minikube
  multipass
  nmap
  node
  nomad
  npm
  nvm
  pip
  pipenv
  postgres
  python
  rake
  rbenv
  redis-cli
  ruby
  systemadmin
  terraform
  vagrant
  vault
  virtualenv
  vscode
  yarn

  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"
# source "$HOME/.zprofile"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
