#!/bin/bash

##############################################################################
#  Filename:       .../Pi-hole/docker/build.sh                               #
#  Purpose:        Script that build a docker-compose project                #
#  Authors:        Giulio Coa <34110430+giulioc008@users.noreply.github.com> #
#  License:        This file is licensed under the LGPLv3.                   #
#  Pre-requisites:                                                           #
#                  * docker                                                  #
#                  * docker-compose                                          #
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

### Script ###
script_path="$0"

if ! command -v docker-compose > /dev/null 2> /dev/null; then
  __err "docker-compose isn't installed"
  return 1
elif ! command -v docker > /dev/null 2> /dev/null; then
  __err "docker isn't installed"
  return 1
fi

clear

# Uncomment this line if there is more docker-compose file that you want use or
# if the docker-compose file that you use have a different name from the default name
# i.e.: COMPOSE_FILE=docker-compose.production.yml:docker-compose.test.yml:docker-compose.debug.yml
# shellcheck disable=SC2034
COMPOSE_FILE="$(__get_file docker-compose.yml)"

# Uncomment this line if there isn't a name top-level element into the docker-compose file
# i.e.: COMPOSE_PROJECT_NAME="$(basename "$(dirname "$(__get_file .)")")"
#       COMPOSE_PROJECT_NAME='Generic Docker Compose project'
# shellcheck disable=SC2034
COMPOSE_PROJECT_NAME='Pi-hole service'

docker-compose rm -v --force --stop 2> /dev/null
docker-compose down --volumes --rmi 'local' --remove-orphans 2> /dev/null
docker volume prune --force 2> /dev/null

docker-compose up --force-recreate --always-recreate-deps --no-start --build --remove-orphans
