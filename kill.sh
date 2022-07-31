#!/bin/bash

#########################################################################
#	Filename:		.../dotfiles/kill.sh							                  			#
#	Purpose:		File that manage kill and killall				            			#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.	        					#
#########################################################################

# kill all the instance of a program
kill-kill() {
  # the parameter $1 is the name of the program that you want kill
  killall --signal KILL --verbose --ignore-case "${1}"
}

# kill all the PID's into the file processes_to_kill.txt
kills() {
  local kill_path
  local buffer

  if kill_path="$(find "${HOME}" -type f -regex '.*/processes_to_kill\.txt' 2> /dev/null)" &&
    [[ -f "${kill_path}" ]]; then
    buffer=''

    while read -r i; do
      buffer="${buffer}${i} "
    done < "${kill_path}"

    rm --recursive --force "${kill_path}"

    # remove the last whitespace
    buffer="${buffer:0:${#buffer}-1}"

    kill --signal KILL "${buffer}" > /dev/null
  else
    echo -e "${bold_red:-}There aren't process in background.${reset:-}" > /dev/stderr
    return 1
  fi
}
