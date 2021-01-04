# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:$DOTFILES/:/usr/local/bin:usr/share:/snap/bin:$PATH

# For easily navigating/specifying custom omz locations
# Also good for easily navigating to my dotfiles directory
CUSTOMPLUGINS=$ZSH_CUSTOM/plugins
CUSTOMTHEMES=$ZSH_CUSTOM/themes
DOTFILES=$HOME/.dotfiles
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"

# Because powerlevel10k doesn't already start at the bottom
printf '\n%.0s' {1..100}

# ---------------------------
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
# For alternate ZSH custom folder path
# ZSH_CUSTOM=/path/to/new-custom-folder
# ---------------------------

# Enable command auto-correction?
ENABLE_CORRECTION="false"
# Use case-sensitive completion?
CASE_SENSITIVE="false"
#------------------------
# Standard plugins can be found in $ZSH/plugins/
plugins=(
alias-finder
autojump
colored-man-pages
colorize
common-aliases
conda-zsh-completion
cp
debian
docker
docker-compose
docker-machine
dotenv
extract
fzf
git
git-auto-fetch
git-extras
git-flow
github
git-hubflow
gitignore
git-lfs
git-prompt
last-working-dir
man
node
npm
perms
pip
pipenv
please
pyenv
python
sudo
systemd
thefuck
themes
vscode
zsh-autosuggestions
zsh-syntax-highlighting
zsh_reload
) # Others should be added to $ZSH_CUSTOM/plugins/
source $ZSH/oh-my-zsh.sh
#------------------------

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nano'
 else
   export EDITOR='nano'
 fi

# Aliases can be placed here, though oh-my-zsh users 
# are encouraged to define aliases within the ZSH_CUSTOM folder.
# 'alias' command will print a list of every alias

# Shortcut aliases
#-------------------
alias ohmyzsh="~/.oh-my-zsh"
alias codeinpython="~/Documents/PythonProjects"
alias codeinjs="~/Documents/JavaScriptProjects"
alias e='echo'
alias ffs='sudo'
# aliases for docker, apt commands, getting IP info etc.
#-------------------
alias d='docker'
alias dps='docker ps'
alias symlink='sudo ln -sfv'
alias fix='sudo apt-get install -f'
alias update='sudo parrot-upgrade -y'
alias aget='sudo apt-get'
alias apt='sudo apt'
alias acache='sudo apt-cache'
alias clean='sudo apt-get autoremove -y && sudo apt-get autoclean -y'
alias extip='curl https://ipecho.net/plain; echo'
alias intip='hostname -I; echo'
alias shutdown='sudo shutdown now'
alias restart='sudo reboot'
alias help='run-help'
alias sysctl='sudo systemctl'
alias sysd='sudo systemd'
#-------------------

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/doc/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/doc/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/doc/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/doc/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/.p10k.zsh.
[[ ! -f ~/.dotfiles/.p10k.zsh ]] || source ~/.dotfiles/.p10k.zsh
