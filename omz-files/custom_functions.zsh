# FUNCTIONS

# COLORS (to make help message look pretty)
# color_off='\033[0m'
# Regular Colors
Purple=`tput setaf 0`
Red=`tput setaf 1`
Green=`tput setaf 2`
Brown=`tput setaf 3`
Blue=`tput setaf 4`
Magenta=`tput setaf 5`
Cyan=`tput setaf 6`
White=`tput setaf 7`
Black=`tput setaf 8`

# displays helpful info if $HELP_MSG is true
# considering splitting up certain parts of this function into smaller function messages
info-message() {
  echo -e $Red'             USEFUL COMMANDS\n'
  echo -e $Blue'GENERAL(those with -ffs in command use sudo):'
  echo -e '"s" (sudo) | "rt" (switch to root user) | "e" (echo)'
  echo -e '"cpd" (copy directory & contents in it) | "sl" (symlink w/ -srv options set)'
  echo -e '"sinfo" will dispay information about your system (and this entire message).'
  echo -e '"cleanzsh" removes zcompdump and .zwc files in your zsh directory.'
  echo -e '"sctl" sudo systemctl | "sd" sudo systemd'
  echo -e 'Use "own" to take ownership of files. Use "owndir" to recursively take ownership of directories.'
  echo -e 'Use "z" to change to $ZDOTDIR. Use "cheat" to lookup cheatsheets if needing help.\n'
  echo -e $Cyan'APT/DPKG:\n"apc" clean up apt pkgs | "afix" apt-get install -f'
  echo -e '"a" apt | "ag" apt-get | "ac" apt-cache'
  echo -e '"au" update | "ai" install | "ar" reinstall | "arm" remove | "ap" purge | "ase" search | "ash" show'
  echo -e '"mark-a" apt-mark auto | "mark-m" apt-mark manual'
  echo -e '"reconf"  dpkg-reconfigure | "add-arch" dpkg --add-architecture\n'
  echo -e 'GIT related commands:\n"gcedit" edit git commit msg | "gst" status | "gsw" switch branch | "gl" pull | "gp" push | "gca" commit all'
  echo -e '"prcreate" gh pr create --fill | "prmerge" gh pr merge'
}

# Because getting told "there is no list of special help topoics available at this time." is just not helpful enough
better-help() {
  if [ "$*" = "" ]
  then
    info-message
  else
    run-help "$1"
  fi
}
alias help='better-help'

# this will show all Powerlevel10K prompt elements
powerlevel-elements() {
  typeset -A reply
  p10k display -a '*'
  printf '%-32s = %q\n' ${(@kv)reply} | sort
}

# edit recent git commit
function gcedit() {
  git add .
  if [ "$1" != "" ]
  then
  	git commit -m "$1"
  else
  	git commit -m update # default commit message is `update`
  fi
}

# cheat sheets (github.com/chubin/cheat.sh), find out how to use commands
# example 'cheat tar'
# for language specific question supply 2 args first for language, second as the question
# eample: cheat python3 execute external program
cheat() {
  if [ "$2" ]
  then
	  curl "https://cheat.sh/$1/$2+$3+$4+$5+$6+$7+$8+$9+$10"
  else
  	curl "https://cheat.sh/$1"
fi
}

speedtest() {
  curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -
}

echo_colormap() {
  for i in {0..255}; do
    print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
  done
}

install_omz_plugin() {
  if [ $# -eq 1 ]
  then
    local plugin=$1
    local name=$(echo "${plugin##*/}" | cut -f 1 -d '.')
    if [ -d $ZSH/custom/plugins/$name ]
    then
      cd $ZSH/custom/plugins/$name && git pull
    else
      git clone --depth=1 $plugin $ZSH/custom/plugins/$name
    fi
  else
    echo "Command requires a single argument"
  fi
}
