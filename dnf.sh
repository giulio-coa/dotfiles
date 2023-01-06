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

if ! command -v sudo > /dev/null 2> /dev/null; then
  echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
  exit 1
elif ! command -v dnf > /dev/null 2> /dev/null; then
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

  if ! options=$(getopt --name "${0}" --options 'hr:' --longoptions 'help,release:' -- "$@"); then
    echo -e "${bold_red:-}getopt command has failed.${reset:-}" > /dev/stderr
    return 2
  fi

  eval set -- "${options}"

  while true; do
    case "${1}" in
      -h | --help)
        echo './start.sh [options]'
        echo
        echo 'Options:'
        echo -e '\t-h, --help: Print this menu'
        echo -e '\t-r <release_number>, --release <release_number>: Update the system to the specified release'
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

  # PackageKit support
  if command -v pkcon > /dev/null 2> /dev/null; then
    sudo pkcon refresh && sudo pkcon update
  fi

  {
    sudo dnf distro-sync
    sudo dnf upgrade
  } && dnf-clear

  if [[ -n "${release}" ]]; then
    if ! command -v dnf-plugin-system-upgrade > /dev/null 2> /dev/null; then
      sudo dnf --assumeyes --quiet install dnf-plugin-system-upgrade
    fi

    sudo dnf system-upgrade download --best --allowerasing --refresh --releasever="${release}" \
      && sudo dnf system-upgrade reboot
  fi
}
