#!/bin/bash

#############################################################################
#	Filename:		    .../dotfiles/apt.sh									                  		#
#	Purpose:	    	File that manage the package manager apt				        	#
#	Authors:	    	Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:    		This file is licensed under the LGPLv3.			        			#
#	Pre-requisites:															                            	#
#				        	* apt									                          					#
#				        	* sudo								                        						#
#############################################################################

if ! command -v sudo > /dev/null 2> /dev/null; then
  echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
  exit 1
elif ! command -v apt > /dev/null 2> /dev/null; then
  echo -e "${bold_red:-}apt isn't installed${reset:-}" > /dev/stderr
  exit 1
fi

# Clear un-needed dipendecies
apt-clear() {
  sudo apt autoremove
  sudo apt clean all
}

# Remove packages, their dependencies not required and configurations
apt-remove() {
  # the parameter $@ is the list of package that you want remove
  sudo apt purge "$@" && apt-clear
}

# Upgrade all packages
apt-upgrade() {
  # PackageKit support
  if command -v pkcon > /dev/null 2> /dev/null; then
    sudo pkcon refresh && sudo pkcon update
  fi

  {
    sudo apt update
    sudo apt dist-upgrade
    sudo apt full-upgrade
  } && apt-clear
}
