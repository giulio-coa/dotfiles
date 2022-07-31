#!/bin/bash

#############################################################################
#	Filename:		    .../dotfiles/dnf.sh		                       				  		#
#	Purpose:	    	File that manage the package manager dnf            			#
#	Authors:	    	Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:	    	This file is licensed under the LGPLv3.			        			#
#	Pre-requisites:													                             			#
#				        	* dnf												  	                        	#
#				        	* sudo														                        #
#############################################################################

set -e

if ! command -v sudo &> /dev/null; then
  echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
  exit 1
elif ! command -v dnf &> /dev/null; then
  echo -e "${bold_red:-}dnf isn't installed${reset:-}" > /dev/stderr
  exit 1
fi

# Clear unneeded dipendecies
dnf-clear() {
  sudo dnf autoremove
  sudo dnf clean all
}

# Remove packages, their dependencies not required and configurations
dnf-remove() {
  # the parameter $@ is the list of package that you want remove
  sudo dnf remove "$@" && dnf-clear
}

# Upgrade all packages
dnf-upgrade() {
  local release
  local options

  # set the flag to don't update the system
  release=''

  if ! command -v dnf-plugin-system-upgrade &> /dev/null; then
    sudo dnf --assumeyes --quiet install dnf-plugin-system-upgrade
  fi

  if ! options=$(getopt --name "${0}" --options 'hr:' --longoptions 'help,release:' -- "$@"); then
    echo -e "${bold_red:-}getopt command has failed.${reset:-}" > /dev/stderr
    return 2
  fi

  eval set -- "${options}"

  while true; do
    case "${1}" in
      -h | --help)
        printf './start.sh [options]\n\n'
        printf 'Options:\n'
        printf '\t-h, --help: Print this menu\n'
        printf '\t-r <release_number>, --release <release_number>: Update the system to the specified release\n'
        return 0
        ;;
      -r | --release)
        release="${2}"

        shift 2
        continue
        ;;
      --)
        shift
        break
        ;;
      *)
        echo -e "${bold_red:-}Internal error.${reset:-}" > /dev/stderr
        return 3
        ;;
    esac
  done

  # DE (desktop enviroment) section
  ## KDE
  if command -v pkcon &> /dev/null; then
    sudo pkcon refresh && sudo pkcon update
  fi

  {
    sudo dnf distro-sync
    sudo dnf upgrade
  } && dnf-clear

  if [[ -n "${release}" ]]; then
    sudo dnf system-upgrade download --best --allowerasing --refresh --releasever="${release}" &&
      sudo dnf system-upgrade reboot
  fi
}
