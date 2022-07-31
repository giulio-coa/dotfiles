#!/bin/bash

#############################################################################
#	Filename:	    	.../check_IP/check_IP.sh								                	#
#	Purpose:	    	Script that checks the public IP of the router	    			#
#	Authors:    		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:	    	This file is licensed under the LGPLv3.					        	#
#	Pre-requisites:														                            		#
#					        * sudo		                         												#
#############################################################################

set -e

__help() {
  printf './start.sh [options]\n\n'
  printf 'Options:\n'
  printf '\t-h, --help: Print this menu\n'
  printf '\t-p, --post: Determine if the program must post the IP on a site\n'
}

__install_dependencies() {
  if ! command -v curl &> /dev/null; then
    # Alpine Linux
    if command -v apk &> /dev/null; then
      sudo apk --quiet --no-cache add curl
    # Debian-based distro
    elif command -v apt &> /dev/null; then
      sudo apt install --assume-yes --quiet curl
    # MacOS distro
    elif command -v brew &> /dev/null; then
      sudo brew install curl
    # Fedora
    elif command -v dnf &> /dev/null; then
      sudo dnf --assumeyes --quiet install curl
    # Gentoo
    elif command -v emerge &> /dev/null; then
      sudo emerge --quiet y curl
    # Arch Linux
    elif command -v pacman &> /dev/null; then
      sudo pacman --sync --needed --noconfirm --quiet curl
    fi
  fi
}

__checkIP() {
  local reset bold_red
  local __POST
  local IP_file_path FTP_file_path
  local options

  # colors
  reset='\e[0m'
  bold_red='\e[1;31m'

  if ! command -v sudo &> /dev/null; then
    echo -e "${bold_red}sudo isn't installed${reset}" > /dev/stderr
    return 1
  fi

  # shellcheck disable=1091
  . .env

  __install_dependencies

  __POST=0

  IP_file_path="${HOME}/ip.txt"
  FTP_file_path="${HOME}/ftp.txt"

  if ! options=$(getopt --name "${0}" --options 'hp' --longoptions 'help,post' -- "$@"); then
    echo -e "${bold_red}getopt command has failed.${reset}" > /dev/stderr
    return 2
  fi

  eval set -- "${options}"

  while true; do
    case "${1}" in
      -h | --help)
        __help
        return 0
        ;;
      -p | --post)
        __POST=1

        shift
        continue
        ;;
      --)
        shift
        break
        ;;
      *)
        echo -e "${bold_red}Internal error.${reset}" > /dev/stderr
        return 3
        ;;
    esac
  done

  curl --location --fail https://ip6.me/api/ 2> /dev/null |
    cut --delimiter=',' --fields=2 > "${IP_file_path}"
  date >> "${IP_file_path}"

  if [[ "${__POST}" -eq 1 ]]; then
    {
      printf 'ascii\n'
      printf 'bell\n'
      printf 'case\n'
      printf 'trace\n'
      printf 'user %s %s\n' "${USERNAME:?}" "${PASSWORD:?}"
      printf 'send %s %s\n' "${IP_file_path}" "${PATH_ON_REMOTE_MACHINE:?}"
      printf 'bye\n'
    } > "${FTP_file_path}"

    ftp --no-login --no-glob --no-prompt --verbose "${FTP_SERVER_NAME:?}" < "${FTP_file_path}"

    rm --recursive --force "${FTP_file_path}"
  else
    cat "${IP_file_path}"
  fi

  rm --recursive --force "${IP_file_path}"
}

__checkIP "$@"
