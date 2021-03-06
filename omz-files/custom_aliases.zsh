# ALIASES

# Useful stuff
alias s='sudo'
alias rt='sudo -i'
alias e='echo'
alias update-db="sudo updatedb --prunepaths='/timeshift/snapshots /media /run/timeshift /run/user'"
alias own='sudo chown -v $USER:$USER'
alias owndir='sudo chown -R $USER:$USER'
alias z='cd $ZDOTDIR'
alias zdir="$ZDOTDIR/"
# copy, symlinks
alias cpd='cp -r'
alias cpd-ffs='sudo cp -r'
alias sl='ln -srv'
alias sl-ffs='sudo ln -srv'
alias rma='rm -drf'
alias rma-ffs-'sudo rm -drf'
# clean zcomp and zwc zsh files
alias cleanzsh='rm -f ${ZDOTDIR:-$HOME}/.zcompdump* && rm -f ${ZDOTDIR:-$HOME}/.zshrc.zwc'

if (( $+commands[parrot-upgrade] )); then
	alias sys-update='sudo parrot-upgrade'
fi

if (( $+commands[neofetch] )); then
	alias sinfo='neofetch && info-message'
fi

if (( $+commands[fuck] )); then
	alias fk='fuck'
fi

# apt/apt-get
if (( $+commands[apt] && $+commands[apt-get] )); then
	alias a='sudo apt'
	alias ag='sudo apt-get'
	alias ac='sudo apt-cache'
	alias alu='apt list --upgradeable'
	alias ase='apt search'
	alias ash='apt show'
	alias au='sudo apt-get update'
	alias ai='sudo apt install'
	alias ar='sudo apt reinstall'
	alias arm='sudo apt remove'
	alias ap='sudo apt purge'
	alias mark-a='sudo apt-mark auto'
	alias mark-m='sudo apt-mark manual'
	alias afix='sudo apt-get install -f'
	alias apc='sudo apt-get --purge autoremove -y && sudo apt-get autoclean -y'
fi

alias reconf='sudo dpkg-reconfigure'
alias add-arch='sudo dpkg --add-architecture'

# git aliases
if (( $+commands[gh] )); then
	alias prcreate='gh pr create --fill'
	alias prmerge='gh pr merge'
fi

# docker aliases
if (( $+commands[docker] )); then
	alias d='docker'
	alias dps='docker ps'
fi

if (( $+commands[conda] )); then
	alias c='conda activate'
fi

# ip info aliases and other system aliases
alias extip='curl https://ipecho.net/plain; echo'
alias intip='hostname -I; echo'
alias shutdown='sudo shutdown now'
alias sctl='sudo systemctl'
alias sd='sudo systemd'
