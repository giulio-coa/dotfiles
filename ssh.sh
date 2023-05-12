#!/bin/bash

##############################################################################
#  Filename:       .../dotfiles/ssh.sh                                       #
#  Purpose:        File that manage ssh                                      #
#  Authors:        Giulio Coa <34110430+giulioc008@users.noreply.github.com> #
#  License:        This file is licensed under the LGPLv3.                   #
#  Pre-requisites:                                                           #
#                  * ssh                                                     #
##############################################################################

if ! command -v ssh > /dev/null 2> /dev/null; then
  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: ${bold_red:-}ssh isn't installed${reset:-}" > /dev/stderr
  exit 1
fi

# Use the Diffie-Hellman algorithm to exchange
# the key when the connection is established
ssh-df() {
  ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostKeyAlgorithms=+ssh-dss  "$@"
}

