#!/bin/bash

##############################################################################
#  Filename:       .../check_IP/check_IP.sh                                  #
#  Purpose:        Script that checks the public IP of the router            #
#  Authors:        Giulio Coa <34110430+giulioc008@users.noreply.github.com> #
#  License:        This file is licensed under the LGPLv3.                   #
#  Pre-requisites:                                                           #
#                  * sudo                                                    #
##############################################################################

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

__help() {
  echo './start.sh [options]'
  echo
  echo 'Options:'
  echo -e '\t-h, --help: Print this menu'
  echo -e '\t-p, --post: Determine if the program must post the IP on a site'
}

__install_dependencies() {
  if ! command -v curl > /dev/null 2> /dev/null; then
    # Alpine Linux
    if command -v apk > /dev/null 2> /dev/null; then
      sudo apk --quiet --no-cache add curl
    # Debian-based distro
    elif command -v apt > /dev/null 2> /dev/null; then
      sudo apt install --assume-yes --quiet curl
    # MacOS distro
    elif command -v brew > /dev/null 2> /dev/null; then
      sudo brew install curl
    # Fedora
    elif command -v dnf > /dev/null 2> /dev/null; then
      sudo dnf --assumeyes --quiet install curl
    # Gentoo
    elif command -v emerge > /dev/null 2> /dev/null; then
      sudo emerge --quiet y curl
    # Arch Linux
    elif command -v pacman > /dev/null 2> /dev/null; then
      sudo pacman --sync --needed --noconfirm --quiet curl
    fi
  fi
}

__checkIP() {
  local __POST
  local IP_file_path FTP_file_path
  local options

  if ! command -v sudo > /dev/null 2> /dev/null; then
    __err "sudo isn't installed"
    return 1
  fi

  source "$(__get_file .env)"

  __install_dependencies

  __POST=0
  IP_file_path="$(mktemp --suffix '.txt')"
  FTP_file_path="$(mktemp --suffix '.txt')"

  if ! options=$(getopt --name "${0}" --options 'hp' --longoptions 'help,post' -- "$@"); then
    __err 'getopt command has failed'
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
        __err 'Internal error' > /dev/stderr
        return 3
        ;;
    esac
  done

  curl --location --fail https://ip6.me/api/ 2> /dev/null \
    | cut --delimiter ',' --fields 2 > "${IP_file_path}"
  date >> "${IP_file_path}"

  if [[ "${__POST}" -eq 0 ]]; then
    cat "${IP_file_path}"
    return 0
  fi

  {
    echo 'ascii'
    echo 'bell'
    echo 'case'
    echo 'trace'
    echo "user ${USERNAME:?} ${PASSWORD:?}"
    echo "send ${IP_file_path} ${PATH_ON_REMOTE_MACHINE:?}"
    echo 'bye'
  } > "${FTP_file_path}"

  ftp --no-login --no-glob --no-prompt --verbose "${FTP_SERVER_NAME:?}" < "${FTP_file_path}"
}

### Script ###
script_path="$0"

__checkIP "$@"
