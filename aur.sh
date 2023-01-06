#!/bin/bash

###############################################################################################
#	Filename:		    .../dotfiles/aur.sh													                              	#
#	Purpose:	    	File that manage the package manager AUR				                  					#
#	Authors:	    	Giulio Coa <34110430+giulioc008@users.noreply.github.com>, Christian Mondo	#
#	License:	    	This file is licensed under the LGPLv3.		                  								#
#	Pre-requisites:																		                                      		#
#					        * pacman														                                  			#
#					        * sudo																                                  		#
#					        * yay (https://github.com/Jguer/yay)	                    									#
###############################################################################################

if ! command -v sudo > /dev/null 2> /dev/null; then
  echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
  exit 1
elif ! command -v pacman > /dev/null 2> /dev/null; then
  echo -e "${bold_red:-}pacman isn't installed${reset:-}" > /dev/stderr
  exit 1
elif ! command -v yay > /dev/null 2> /dev/null; then
  echo -e "${bold_red:-}yay isn't installed${reset:-}" > /dev/stderr
  exit 1
fi

# Clear unneeded dipendecies
aur-clear() {
  yay --yay --clean
}

# Install from AUR or repository
aur-install() {
  # the parameter $@ is the list of package that you want install
  yay --sync --answerclean A --answerdiff N --removemake "$@"
}

# List explicitly installed AUR packages
aur-list-installed() {
  sudo pacman --query --explicit --foreign
}

# List installed AUR packages
aur-list-installed-all() {
  sudo pacman --query --foreign
}

# Remove packages, their dependencies not required and configurations
aur-remove() {
  # the parameter $@ is the list of package that you want remove
  sudo pacman --remove --nosave --recursive "$@" && aur-clear
}

# Upgrade all AUR packages
aur-upgrade() {
  # PackageKit support
  if command -v pkcon > /dev/null 2> /dev/null; then
    sudo pkcon refresh && sudo pkcon update
  fi

  yay --sync --refresh --sysupgrade --aur --answerclean A --answerdiff N --removemake \
    && aur-clear
}
