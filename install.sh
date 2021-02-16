#!/bin/bash

# check if necessary packages are installed
if command -v zsh &> /dev/null && command -v git &> /dev/null && command -v wget && command -v neofetch &> /dev/null; 
then
    printf "Zsh, Git, wget and neofetch are already installed\n"
else
    if sudo apt install -y zsh git wget neofetch || sudo pacman -S zsh git wget neofetch || sudo dnf install -y zsh git wget neofetch || sudo yum install -y zsh git wget neofetch || pkg install git zsh wget neofetch;
    then
        printf "Zsh, Git, wget and neofetch installed.\n"
    else
        printf "Please install the following packages first, then try again: zsh git wget neofetch\n" && exit
    fi
fi

CLONED_REPO=$(pwd)

# move cloned repo to home directory if not already there
if [[ ! -d $HOME/Dotfiles ]]; then
printf "Moving cloned Dotfiles repo directory to user's home directory.\n"
    cd $HOME && mv $CLONED_REPO $HOME/Dotfiles
    cd $HOME/Dotfiles && CLONED_REPO=$(pwd)
fi

# HOMEBREW/LINUXBREW INSTALL
if command -v brew &> /dev/null; then
    printf "Homebrew is already installed.\n"
else
    printf "Homebrew not installed.\n" 
    while true; do
        read -p "Do you want to install Homebrew? [Y/n]:" yn
        case $yn in
            [Yy]* )
                printf "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                break
                ;;
            [Nn]* )
                printf "Homebrew will not be installed.\nContinuing..."
                break
                ;;
            * )
                printf "Please provide a valid answer."
                ;;
        esac
    done
fi

# MINICONDA INSTALL
if [ -d $HOME/miniconda3 ]; then
    printf "Miniconda3 is already installed.\n"
else
    printf "Miniconda3 is not installed.\n"
    while true; do
        read -p "Do you want to install Miniconda? [Y/n]:" yn
        case $yn in
            [Yy]* )
                printf "Be sure to install Miniconda3 within your user's home directory.\n"
                if [ -f $HOME/Miniconda3-latest-Linux-x86_64.sh ]; then # to prevent downloading Miniconda3 setup file multiple times
                    printf "Miniconda3 is already downloaded\n"
                    printf "Starting Miniconda3 setup...\n"
                    bash $HOME/Miniconda3-latest-Linux-x86_64.sh
                else
                    printf "Downloading Miniconda3..."
                    wget -q --show-progress https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P $HOME/
                    printf "Download finished.\n"
                    printf "Starting Miniconda3 setup...\n"
                    bash $HOME/Miniconda3-latest-Linux-x86_64.sh
                fi
                break
                ;;
            [Nn]* )
                printf "Answer: No.\n"
                printf "Continuing...\n" && sleep 1
                break
                ;;
            * )
                printf "Please provide a valid answer.\n"
                ;;
        esac
    done
fi

# INSTALL CLEANUP
if [ -f ~/Miniconda3-latest-* ] && [ -d ~/miniconda3 ]; then
    printf "Removing Miniconda3 install file...\n"
    ls -l ~/Miniconda3-latest-*
    rm -f ~/Miniconda3-latest-*
fi

# ASK TO BACKUP FILES --- ZSH CONFIG INSTALLS BEGIN AFTER THIS
while true; do
    printf "Are there dotfiles in your home directory that you want to backup?\n"
    read -p "Backup existing dotfiles in home directory? [Y/n]:" yn
    case $yn in
        [Yy]* )
            printf "Starting backup...\n"
            mkdir -p $HOME/Backup_Dotfiles # Create file backup directory
            if [ -f $HOME/.zprofile ]; then
                printf "Found .zprofile, backing up file to $HOME/Backup_Dotfiles...\n"
                mv $HOME/.zprofile $HOME/Backup_Dotfiles/.zprofile-backup-$(date +"%Y-%m-%d")
                printf "Backed up current .zprofile to .zprofile-backup-$(date +"%Y-%m-%d")\n"
            fi
            if [ -f $HOME/.zshenv ]; then
                printf "Found .zshenv, backing up file to $HOME/Backup_Dotfiles...\n"
                mv $HOME/.zshenv $HOME/Backup_Dotfiles/.zshenv-backup-$(date +"%Y-%m-%d")
                printf "Backed up current .zshenv to .zshenv-backup-$(date +"%Y-%m-%d")\n"
            fi
            if [ -f $HOME/.zshrc ]; then # backup .zshrc
                printf "Found .zshrc, backing up file to $HOME/Backup_Dotfiles...\n"
                mv $HOME/.zshrc $HOME/Backup_Dotfiles/.zshrc-backup-$(date +"%Y-%m-%d")
                printf "Backed up current .zshrc to .zshrc-backup-$(date +"%Y-%m-%d")\n"
            fi
            printf "Finished backing up any existing zsh files. Continuing...\n" && sleep 1
            break
            ;;
        [Nn]* )
            printf "Will continue without trying to backup existing files. Continuing...\n" && sleep 1
            break
            ;;
        * )
            printf "Please provide a valid answer.\n"
            ;;
    esac
done


# CHOOSE INSTALL DIRECTORY
while true; do
    if [[ ! -e "$INSTALL_DIRECTORY" ]]; then
        printf "\n"
        printf "Where should your zsh and oh-my-zsh configuration files be installed?\n"
        printf "!!!(FYI - the location should be in your user's home directory)\n"
        printf "\n"
        printf "Default install directory is: $INSTALL_DIRECTORY\n"
        printf "  - Press ENTER to confirm the location\n"
        printf "  - Press CTRL-C to abort the installation\n"
        printf "  - Or specify a different location below\n"
        printf "[%s] >>> " "$INSTALL_DIRECTORY"
        read -r user_prefix
        if [ "$user_prefix" != "" ]; then
            case "$user_prefix" in
                *\ * )
                    printf "ERROR: Cannot install into directories with spaces\n" >&2
                    continue
                    ;;
                *)
                    eval INSTALL_DIRECTORY="$user_prefix"
                    ;;
            esac
        fi
        # check if user entry contained spaces
        case "$INSTALL_DIRECTORY" in
            *\ * )
                printf "!!!\n"
                printf "ERROR: Cannot install into directories with spaces\n" >&2
                continue
                ;;
        esac
        # if directory exists, don't try creating it
        if [ -e "$INSTALL_DIRECTORY" ]; then
            printf "\n"
            printf "Directory already exists, no need to create it.\n"
            break
        else
            if mkdir -p "$INSTALL_DIRECTORY" 2>/dev/null; then
                printf "\n"
                printf "Directory created.\n" && ls -ld "$INSTALL_DIRECTORY" && sleep 1
                break
            else # let user know we couldn't create directory
                printf "!!!\n"
                printf "Couldn't create directory: $INSTALL_DIRECTORY \n"
                printf "Make sure you have the correct permissions to create the directory.\n" && sleep 1
                INSTALL_DIRECTORY=$HOME/.config/zsh
                continue
            fi
        fi
    else
        printf "\n"
        printf "$INSTALL_DIRECTORY already exists. No need to create it.\n"
        printf "Continuing...\n"
        break
    fi
done


# OMZ INSTALL
printf "\n"
printf "Installing oh-my-zsh\n" && sleep 1
export ZSH=$INSTALL_DIRECTORY/.oh-my-zsh
if [ -d $HOME/.oh-my-zsh ]; then # OMZ already installed, but located in user's home dir
    printf "oh-my-zsh is already installed in home directory, moving to new $INSTALL_DIRECTORY directory...\n"
    mv $HOME/.oh-my-zsh $INSTALL_DIRECTORY
    cd $INSTALL_DIRECTORY/.oh-my-zsh && git pull
else
    if [ -d $INSTALL_DIRECTORY/.oh-my-zsh ]; then # OMZ installed in install dir
        printf "oh-my-zsh is already installed in $INSTALL_DIRECTORY.\n"
        cd $INSTALL_DIRECTORY/.oh-my-zsh && git pull
    else
        printf "oh-my-zsh is not installed. Installing...\n" # OMZ not installed
        sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
    fi
fi

printf "Ready to install OMZ plugins...\n" && sleep 1


if [ -d $INSTALL_DIRECTORY/.oh-my-zsh ]; then
    # OMZ PLUGINS
    if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
        cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull
    else
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    fi

    if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/conda-zsh-completion ]; then
        cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/conda-zsh-completion && git pull
    else
        git clone --depth=1 https://github.com/esc/conda-zsh-completion.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/conda-zsh-completion
    fi

    if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
        cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
    else
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    fi

    if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autocompletion ]; then
        cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autocompletion && git pull
    else
        git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-autocomplete
    fi

    if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
        cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-history-substring-search && git pull
    else
        git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins/zsh-history-substring-search
    fi
    # POWERLEVEL10K THEME
    if [ -d $INSTALL_DIRECTORY/.oh-my-zsh/custom/themes/powerlevel10k ]; then
        cd $INSTALL_DIRECTORY/.oh-my-zsh/custom/themes/powerlevel10k && git pull
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $INSTALL_DIRECTORY/.oh-my-zsh/custom/themes/powerlevel10k
    fi
else
    printf "Something's wrong, oh-my-zsh isn't in $INSTALL_DIRECTORY...\n"
    printf "Checking if oh-my-zsh is in home directory...\n" && sleep 1
    if [ -d ~/.oh-my-zsh ]; then
        printf "oh-my-zsh is in home directory, will move it to $INSTALL_DIRECTORY...\n"
        mv ~/.oh-my-zsh $INSTALL_DIRECTORY && printf "oh-my-zsh directory moved to $INSTALL_DIRECTORY, can proceed now\n" && sleep 1
    else
        printf "oh-my-zsh is NOT in home directory, something is wrong\n"
        printf "Exitting before attempting anything further\n" && sleep 1
        exit
    fi
fi

# INSTALL EMOJI FONTS IF NONE FOUND
if fc-list | grep -i emoji >/dev/null; then
    printf "Emoji fonts found, won't install any more. If emojis are missing try downloading fonts-noto-color-emoji and fonts-recommended packages\n"
else
    if sudo apt install -y fonts-noto-color-emoji fonts-recommended || sudo pacman -S fonts-noto-color-emoji fonts-recommended || sudo dnf install -y fonts-noto-color-emoji fonts-recommended || sudo yum install -y fonts-noto-color-emoji fonts-recommended || pkg install fonts-noto-color-emoji fonts-recommended;
    then
        printf "Fonts to show latest emojis are installed\n"
    else
        printf "Couldn't install fonts, latest emojis may not show correctly\n"
    fi
fi

# INSTALL NERD FONTS
while true; do
    printf "\nWould you like to install nerd fonts?\n"
    read -p "Install nerd fonts? [Y/n]:" yn
    case $yn in
        [Yy]* )
            printf "\nInstalling various Nerd Fonts...\n"
            # Meslo LG S Regular Nerd Font
            if [ -f $HOME/.fonts/Meslo\ LG\ S\ Regular\ Nerd\ Font\ Complete.ttf ]; then
                printf "Meslo LG S Regular Nerd Font already installed.\n"
            else
                printf "Installing Meslo LG S Regular Nerd Font Complete...\n"
                wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S/Regular/complete/Meslo%20LG%20S%20Regular%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
            fi
            # DejaVu Sans Mono Nerd Font
            if [ -f $HOME/.fonts/DejaVu\ Sans\ Mono\ Nerd\ Font\ Complete.ttf ]; then
                printf "DejaVu Sans Mono Nerd Font already installed.\n"
            else
                printf "Installing DejaVu Sans Mono Nerd Font Complete...\n"
                wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
            fi
            # Roboto Mono Nerd Font
            if [ -f $HOME/.fonts/Roboto\ Mono\ Nerd\ Font\ Complete.ttf ]; then
                printf "Roboto Mono Nerd Font already installed.\n"
            else
                printf "Installing Roboto Mono Nerd Font Complete...\n"
                wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/complete/Roboto%20Mono%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
            fi
            # Hack Regular Nerd Font
            if [ -f $HOME/.fonts/Hack\ Regular\ Nerd\ Font\ Complete.ttf ]; then
                printf "Hack Nerd Font already installed.\n"
            else
                printf "Installing Hack Regular Nerd Font Complete...\n"
                wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
            fi
            # Sauce Code Pro Nerd Font
            if [ -f $HOME/.fonts/Sauce\ Code\ Pro\ Nerd\ Font\ Complete.ttf ]; then
                printf "Sauce Code Pro Nerd Font already installed.\n"
            else
                printf "Installing Sauce Code Pro Nerd Font Complete...\n"
                wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf -P $HOME/.fonts/
            fi
            # Scan new fonts and build font information cache files
            fc-cache -fv $HOME/.fonts
            break
            ;;
        [Nn]* )
            printf "\nWill not install Nerd Fonts. Continuing...\n";
            break
            ;;
        * )
            printf "\nPlease provide a valid answer.\n"
            ;;
    esac
done

# COPY FILES FROM REPO
# the two .zsh files in omz-files need to go in .oh-my-zsh/custom/
cd $CLONED_REPO/omz-files
for i in *; do
    if [ -f $i ]; then
        if [ "$i" = "_better-help" ]; then
            [[ ! -d $INSTALL_DIRECTORY/.oh-my-zsh/completions ]] &&
            mkdir $INSTALL_DIRECTORY/.oh-my-zsh/completions && # in case completions dir isn't there
            cp $i $INSTALL_DIRECTORY/.oh-my-zsh/completions
        else
            cp -f $i $INSTALL_DIRECTORY/.oh-my-zsh/custom
        fi
    elif [ -d $i ]; then # to copy nordvpn completions omz plugin (still hasnt been merged to OMZ stable branch yet but I found it on a test branch)
        cp -rf $i $INSTALL_DIRECTORY/.oh-my-zsh/custom/plugins
    fi
done

# directory for storing Powerlevel10K themes
if [[ ! -d $INSTALL_DIRECTORY/P10K-themes ]]; then
    mkdir -p $INSTALL_DIRECTORY/P10K-themes
fi

# copy repo themes to new P10K-themes directory
cd $CLONED_REPO/P10K-themes
for i in * ; do
    if [ -f $i ]; then
        cp -f $i $INSTALL_DIRECTORY/P10K-themes
    fi
done

# recursively copy all dotfiles in the cloned repo directory (except .gitignore)
cd $CLONED_REPO
for i in .* ; do
    if [ -f $i ]; then
        if [ "$i" != ".gitignore" ]; then
            printf "\nCopying $i to $INSTALL_DIRECTORY\n"
            cp -f $i $INSTALL_DIRECTORY
        fi
    fi
done

printf "\nFinished setting up repo files in new $INSTALL_DIRECTORY directory.\n"
cd $HOME

while true; do
    printf "\nTo set the ZDOTDIR variable required to let Zsh know where to look for the .zsh files, we can either symlink the .zshenv file with the export ZDOTDIR line in it from your install directory, or we can export the variable in /etc/zsh/zshenv.\n"
    printf "If you'd prefer to set it some other way, choose option 3.\n"
    printf "\nHOW SHOULD ZDOTDIR BE SET?\n"
    printf "[1]     Create symbolic link to $INSTALL_DIRECTORY/.zshenv in $HOME directory and append lines exporting ZDOTDIR to it\n"
    printf "[2]     Use /etc/zsh/zshenv file to set ZDOTDIR to $INSTALL_DIRECTORY (may require sudo priviledges)\n"
    printf "[3]     Do nothing; ZDOTDIR is already set, or I am going to set the ZDOTDIR variable myself.\n"
    printf ">>> "
    read -r choice
    case $choice in
        [1] )
            printf "\nCreated symbolic link in home directory:\n"
            ln -sv $INSTALL_DIRECTORY/.zshenv $HOME/.zshenv
            printf "Inserting lines to export ZDOTDIR into .zshenv file...\n"
            echo "\nif [[ ! -n \"\$ZDOTDIR\" ]] && [ -d $INSTALL_DIRECTORY ]; then\n    export ZDOTDIR=$INSTALL_DIRECTORY\nfi" >> $HOME/.zshenv
            sleep 1
            break
            ;;
        [2] )
            echo "\n[[ -d $INSTALL_DIRECTORY && -f $INSTALL_DIRECTORY/.zshrc ]] && export ZDOTDIR=$INSTALL_DIRECTORY" | sudo tee -a /etc/zsh/zshenv > /dev/null
            printf "/etc/zsh/zshenv will now set and export the ZDOTDIR variable. Be sure to modify this file if you wish to change the location of your zsh dotfiles directory.\n" && sleep 1
            break
            ;;
        [3] )
            printf "\nNothing will be done. Continuing on to final steps...\n" && sleep 1
            break
            ;;
        * )
            printf "\nPlease enter a valid choice.\n"
            ;;
    esac
done

export ZDOTDIR=$INSTALL_DIRECTORY

# Change shell to zsh and run omz update
printf "Sudo access is needed to change default shell\n"
if chsh -s $(which zsh); then
    if /bin/zsh -i -c 'omz update'; then
        printf "Installation Successful, exit terminal and enter a new session\n"
    elif /bin/zsh -i -c upgrade_oh_my_zsh; then # in case omz update fails, will fallback to using upgrade_oh_my_zsh to finish install
        printf "Installation Successful, exit terminal and enter a new session\n"
    else
        printf "Something went wrong\n"
    fi
else
    printf "Something went wrong\n"
fi

exit