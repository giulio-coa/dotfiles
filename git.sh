#!/bin/bash

#############################################################################
#	Filename:	    	.../dotfiles/git.sh								                    		#
#	Purpose:	    	File that manage git							                  			#
#	Authors:	    	Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		    This file is licensed under the LGPLv3.	        					#
#	Pre-requisites:					    		                        									#
#					        * git		                          												#
#############################################################################

if ! command -v git > /dev/null 2> /dev/null; then
  echo -e "${bold_red:-}git isn't installed${reset:-}" > /dev/stderr
  exit 1
fi

# Commit the repositories
git-clean-all() {
  git reset --hard
  git clean --force -d
  git stash clear
}
