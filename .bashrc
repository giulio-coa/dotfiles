#################################################################################
#	Filename:		~/.bashrc													#
#	Purpose:		Config file for bash (bourne again shell)					#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.						#
#################################################################################

# Source global definitions
if [ -f /etc/bashrc ]
then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
## Code that must be execute when the shell is opened

# retrieve the path of the repository
repo_path=$(find "${HOME}" -type d -regex '.*/dotfiles' 2> /dev/null)

# check if the repo exists
if [ $? -eq 0 ]
then
    # Uncomment the line that load the script that manage yout package manager

    # include the Shell Script that manage apt
    source "${repo_path}/apt.sh"
    # include the Shell Script that manage dnf
    #source "${repo_path}/dnf.sh"
    # include the Shell Script that manage pacman
    #source "${repo_path}/pacman.sh"
    # include the Shell Script that manage AUR
    #source "${repo_path}/aur.sh"
    # include the Shell Script that define the aliases
    source "${repo_path}/alias.sh"
    # include the Shell Script that manage git
    source "${repo_path}/git.sh"
    # include the Shell Script that manage the background processes
    source "${repo_path}/kill.sh"
    # include the Shell Script that manage the colors on the terminal
    source "${repo_path}/colors.sh"
fi

unset repo_path

# if that manage the creation of the prompt
if [ "${USER}" = 'root' ]
then
	PS1="${bold_red:?}\u${reset:?}@\h \W # "
else
	PS1="${bold_high_intensty_blue:?}\u${reset:?}@\h \W % "
fi

# secondary prompt, printed when the shell needs more information to complete a command
PS2='\`%_> '
# selection prompt, used within a select loop
PS3='?# '
# the execution trace prompt (setopt xtrace)
PS4='+%N:%i:%_> '

# erasing the history of the shell
rm --recursive --force ~/.bash_history

# clearing the shell
clear
