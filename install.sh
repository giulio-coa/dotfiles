#!/bin/bash

##################################################################################################
# Filename:        .../dotfiles/install.sh                                                       #
#  Purpose:        File that create the links for the opportune scripts into the opportune paths #
#  Authors:        Giulio Coa <34110430+giulioc008@users.noreply.github.com>                     #
#  License:        This file is licensed under the LGPLv3.                                       #
#  Pre-requisites:                                                                               #
#                  * sudo                                                                        #
##################################################################################################

### Functions ###
__err() {
  local reset bold_red

  # colors
  reset='\e[0m'
  bold_red='\e[1;31m'

  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: ${bold_red}$@${reset}" > /dev/stderr
}

__get_file() {
  case "${script_path}" in
    /*)
      echo "$(dirname "${script_path}")/$1"
      ;;
    *)
      echo "${PWD}/$(dirname "${script_path}")/$1"
      ;;
  esac
}

__install() {
  local app entry

  if ! command -v sudo > /dev/null 2> /dev/null; then
    __err "sudo isn't installed"
    return 1
  fi

  mkdir --parents "${HOME}/.config"
  sudo mkdir --parents '/root/.config'

  # set Shell configuration files
  if [[ "${SHELL}" == '/bin/bash' ]]; then
    ln --force --symbolic "$(__get_file .bashrc)" "${HOME}/.bashrc"
    sudo ln --force --symbolic "$(__get_file .bashrc)" '/root/.bashrc'
  elif [[ "${SHELL}" == '/bin/zsh' ]]; then
    ln --force --symbolic "$(__get_file .zshrc)" "${HOME}/.zshrc"
    sudo ln --force --symbolic "$(__get_file .zshrc)" '/root/.zshrc'
  fi

  # set Vim configuration files
  if [[ -L "${HOME}/.vim" ]]; then
    rm --recursive --force "${HOME}/.vim"
  fi

  if [[ -L '/root/.vim' ]]; then
    sudo rm --recursive --force '/root/.vim'
  fi

  ln --force --symbolic "$(__get_file .vimrc)" "${HOME}/.vimrc"
  sudo ln --force --symbolic "$(__get_file .vimrc)" '/root/.vimrc'

  ln --force --symbolic "$(__get_file .vim)" "${HOME}/.vim"
  sudo ln --force --symbolic "$(__get_file .vim)" '/root/.vim'

  ## remove duplicates
  if [[ -L "${HOME}/.vim/.vim" ]]; then
    rm --recursive --force "${HOME}/.vim/.vim"
  fi

  if [[ -L '/root/.vim/.vim' ]]; then
    sudo rm --recursive --force '/root/.vim/.vim'
  fi

  # set Git configuration files
  cp "$(__get_file .gitconfig)" "${HOME}/.gitconfig"
  sudo cp "$(__get_file .gitconfig)" '/root/.gitconfig'

  # set applications configuration files
  for app in "$(__get_file .config/)"*; do
    if [[ -L "${HOME}/.config/$(basename "${app}")" ]]; then
      rm --recursive --force "${HOME}/.config/$(basename "${app}")"
    fi

    if [[ -L "/root/.config/$(basename "${app}")" ]]; then
      sudo rm --recursive --force "/root/.config/$(basename "${app}")"
    fi

    ln --force --symbolic "${app}" "${HOME}/.config/$(basename "${app}")"
    sudo ln --force --symbolic "${app}" "/root/.config/$(basename "${app}")"

    ## remove duplicates
    if [[ -L "${HOME}/.config/$(basename "${app}")/$(basename "${app}")" ]]; then
      rm --recursive --force "${HOME}/.config/$(basename "${app}")/$(basename "${app}")"
    fi

    if [[ -L "/root/.config/$(basename "${app}")/$(basename "${app}")" ]]; then
      sudo rm --recursive --force "/root/.config/$(basename "${app}")/$(basename "${app}")"
    fi
  done

  for entry in "$(__get_file desktop_entries/)"*; do
    if [[ -f "${HOME}/Desktop/$(basename "${entry}")" ]]; then
      continue
    fi

    cp "${entry}" "${HOME}/Desktop/$(basename "${entry}")"
  done

  sudo ln --force --symbolic "$(__get_file usr/share/xournalpp/ui/toolbar.ini)" '/usr/share/xournalpp/ui/toolbar.ini'
}

### Script ###
script_path="$0"

__install
