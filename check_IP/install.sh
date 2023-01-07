#!/bin/bash

#####################################################################################################
# Filename:	    	.../check_IP/install.sh			  										                          			#
#	Purpose:	    	File that create the links for the opportune System Unit into the opportune paths	#
#	Authors:	    	Giulio Coa <34110430+giulioc008@users.noreply.github.com> 		          					#
#	License:	    	This file is licensed under the LGPLv3.											                    	#
#	Pre-requisites:								    													                                    	#
#				        	* sudo			                                    																	#
#####################################################################################################

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
  if ! command -v sudo > /dev/null 2> /dev/null; then
    __err "sudo isn't installed"
    return 1
  fi

  sudo ln --force --symbolic "$(__get_file check_IP.service)" /lib/systemd/system/check_IP.service
  sudo ln --force --symbolic "$(__get_file check_IP.timer)" /lib/systemd/system/check_IP.timer

  sudo ln --force --symbolic "$(__get_file check_IP.service)" /etc/systemd/system/check_IP.service
  sudo ln --force --symbolic "$(__get_file check_IP.timer)" /etc/systemd/system/check_IP.timer
}

### Script ###
script_path="$0"

__install
