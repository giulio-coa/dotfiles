#!/bin/bash

##############################################################################
#  Filename:       .../dotfiles/docker.sh                                    #
#  Purpose:        File that manage docker                                   #
#  Authors:        Giulio Coa <34110430+giulioc008@users.noreply.github.com> #
#  License:        This file is licensed under the LGPLv3.                   #
#  Pre-requisites:                                                           #
#                  * docker                                                  #
#                  * sudo                                                    #
##############################################################################

if ! command -v sudo > /dev/null 2> /dev/null; then
  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: ${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
  exit 1
elif ! command -v docker > /dev/null 2> /dev/null; then
  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: ${bold_red:-}docker isn't installed${reset:-}" > /dev/stderr
  exit 1
fi

# Remove all containers, images and volumes
docker-clean-all() {
  local volume

  sudo docker system prune --all --force --volumes

  for volume in $(sudo docker volume ls \
    | sed --regexp-extended --expression='s/\s+/,/g' \
    | cut --delimiter ',' --fields 2); do
	if [[ "${volume}" == 'VOLUME' ]]; then
	  continue
	fi

    sudo docker volume rm -f "${volume}" > /dev/null
  done
}

# List all containers, images, networks and volumes
docker-list-all() {
  sudo docker container ls --all
  sudo docker image ls --all
  sudo docker network ls
  sudo docker volume ls
}

# Instantiate a Jupyter Docker Container
docker-jupyter() {
  sudo docker run --rm --interactive \
    --tty --name jupyter_01 \
    --publish 8888:8888 \
    jupyter/scipy-notebook:python-3.10
}
