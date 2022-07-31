#!/bin/bash

#####################################################################################################
# Filename:	    	.../check_IP/install.sh			  										                          			#
#	Purpose:	    	File that create the links for the opportune System Unit into the opportune paths	#
#	Authors:	    	Giulio Coa <34110430+giulioc008@users.noreply.github.com> 		          					#
#	License:	    	This file is licensed under the LGPLv3.											                    	#
#	Pre-requisites:								    													                                    	#
#				        	* sudo			                                    																	#
#####################################################################################################

set -e

__install() {
  local dir_path

  if ! command -v sudo &> /dev/null; then
    echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
    return 1
  fi

  if ! dir_path="$(find "${HOME}" -type d -regex '.*/check_IP' 2> /dev/null)"; then
    echo -e "${bold_red:-}find crashed${reset:-}" > /dev/stderr
    return 2
  fi

  sudo ln --force --symbolic "${dir_path}/check_IP.service" /lib/systemd/system/check_IP.service
  sudo ln --force --symbolic "${dir_path}/check_IP.timer" /lib/systemd/system/check_IP.timer

  sudo ln --force --symbolic "${dir_path}/check_IP.service" /etc/systemd/system/check_IP.service
  sudo ln --force --symbolic "${dir_path}/check_IP.timer" /etc/systemd/system/check_IP.timer
}

__install
