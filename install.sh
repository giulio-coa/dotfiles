#!/bin/bash

#################################################################################################
# Filename:	    	.../dotfiles/install.sh			                          						    				#
#	Purpose:	    	File that create the links for the opportune scripts into the opportune paths	#
#	Authors:	    	Giulio Coa <34110430+giulioc008@users.noreply.github.com> 				        		#
#	License:	    	This file is licensed under the LGPLv3.							                  				#
#	Pre-requisites:								    									                                  				#
#			        		* sudo					    										                              				#
#################################################################################################

__install() {
  local repo_path
  local app entry

  if ! command -v sudo > /dev/null 2> /dev/null; then
    echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
    return 1
  elif ! repo_path="$(find "${HOME}" -type d -regex '.*/dotfiles' 2> /dev/null)"; then
    echo -e "${bold_red:-}find crashed${reset:-}" > /dev/stderr
    return 2
  fi

  mkdir --parents "${HOME}/.config"
  sudo mkdir --parents '/root/.config'

  # set Shell configuration files
  if [[ "${SHELL}" == '/bin/bash' ]]; then
    ln --force --symbolic "${repo_path}/.bashrc" "${HOME}/.bashrc"
    sudo ln --force --symbolic "${repo_path}/.bashrc" '/root/.bashrc'
  elif [[ "${SHELL}" == '/bin/zsh' ]]; then
    ln --force --symbolic "${repo_path}/.zshrc" "${HOME}/.zshrc"
    sudo ln --force --symbolic "${repo_path}/.zshrc" '/root/.zshrc'
  fi

  # set Vim configuration files
  if [[ -L "${HOME}/.vim" ]]; then
    rm --recursive --force "${HOME}/.vim"
  fi

  if [[ -L '/root/.vim' ]]; then
    sudo rm --recursive --force '/root/.vim'
  fi

  ln --force --symbolic "${repo_path}/.vimrc" "${HOME}/.vimrc"
  sudo ln --force --symbolic "${repo_path}/.vimrc" '/root/.vimrc'

  ln --force --symbolic "${repo_path}/.vim" "${HOME}/.vim"
  sudo ln --force --symbolic "${repo_path}/.vim" '/root/.vim'

  ## remove duplicates
  if [[ -L "${HOME}/.vim/.vim" ]]; then
    rm --recursive --force "${HOME}/.vim/.vim"
  fi

  if [[ -L '/root/.vim/.vim' ]]; then
    sudo rm --recursive --force '/root/.vim/.vim'
  fi

  # set Git configuration files
  cp "${repo_path}/.gitconfig" "${HOME}/.gitconfig"
  sudo cp "${repo_path}/.gitconfig" '/root/.gitconfig'

  # set applications configuration files
  for app in "${repo_path}/.config/"*; do
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

  for entry in "${repo_path}/desktop_entries/"*; do
    if [[ -f "${HOME}/Desktop/$(basename "${entry}")" ]]; then
      continue
    fi

    cp "${entry}" "${HOME}/Desktop/$(basename "${entry}")"
  done

  sudo ln --force --symbolic "${repo_path}/usr/share/xournalpp/ui/toolbar.ini" '/usr/share/xournalpp/ui/toolbar.ini'
}

__install
