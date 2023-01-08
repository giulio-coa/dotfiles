##########################################################################
#  Filename:    ~/.bashrc                                                #
#  Purpose:    Config file for bash (bourne again shell)                 #
#  Authors:    Giulio Coa <34110430+giulioc008@users.noreply.github.com> #
#  License:    This file is licensed under the LGPLv3.                   #
##########################################################################

# Source global definitions
if [[ -f /etc/bashrc ]]; then
  source /etc/bashrc
fi

# User specific environment
if ! [[ "${PATH}" =~ ${HOME}/.local/bin:${HOME}/bin: ]]; then
  PATH="${HOME}/.local/bin:${HOME}/bin:${PATH}"
fi

export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
## Code that must be execute when the shell is opened

# enable case-insensitive tab completion
if [[ ! -e ~/.inputrc ]]; then
  echo '$include /etc/inputrc' > ~/.inputrc
fi

echo 'set completion-ignore-case On' >> ~/.inputrc

# include personal tools
if repo_path="$(find "${HOME}" -type d -regex '.*/dotfiles$' 2> /dev/null)"; then
  if command -v apt > /dev/null 2> /dev/null; then
    source "${repo_path}/apt.sh"
  elif command -v dnf > /dev/null 2> /dev/null; then
    source "${repo_path}/dnf.sh"
  elif command -v pacman > /dev/null 2> /dev/null; then
    source "${repo_path}/pacman.sh"

    if command -v yay > /dev/null 2> /dev/null; then
      source "${repo_path}/aur.sh"
    fi
  fi

  source "${repo_path}/alias.sh"
  source "${repo_path}/colors.sh"
  source "${repo_path}/docker.sh"
  source "${repo_path}/git.sh"
fi

unset repo_path

if [[ "${USER}" == 'root' ]]; then
  PS1="${bold_red:?}\u${reset:?}${bold_white:?}@\h \w #${reset:?} "
else
  PS1="${bold_high_intensty_blue:?}\u${reset:?}${bold_white:?}@\h \w %${reset:?} "
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
