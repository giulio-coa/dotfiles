#!/bin/bash

################################################################################################
#  Filename:        .../dotfiles/pacman.sh                                                     #
#  Purpose:        File that manage the package manager pacman                                 #
#  Authors:        Giulio Coa <34110430+giulioc008@users.noreply.github.com>, Christian Mondo  #
#  License:        This file is licensed under the LGPLv3.                                     #
#  Pre-requisites:                                                                             #
#                  * pacman                                                                    #
#                  * sudo                                                                      #
################################################################################################

if ! command -v sudo > /dev/null 2> /dev/null; then
  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: ${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
  exit 1
elif ! command -v pacman > /dev/null 2> /dev/null; then
  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: ${bold_red:-}pacman isn't installed${reset:-}" > /dev/stderr
  exit 1
fi

# Remove all the cached packages that are not currently installed and the unused sync database
pacman-clear() {
  sudo pacman --sync --clean
}

# Remove all cached file
pacman-clear-all() {
  sudo pacman --sync --clean --clean
}

# Install list of packages without reinstall the already installed ones
pacman-install() {
  # the parameter $@ is the list of package that you want install
  sudo pacman --sync --needed "$@"
}

# List explicitly installed packages
pacman-list-installed() {
  sudo pacman --query --explicit --native
}

# List installed packages
pacman-list-installed-all() {
  sudo pacman --query --native
}

# Remove packages, their dependencies not required and configurations
pacman-remove() {
  # the parameter $@ is the list of package that you want remove
  sudo pacman --remove --nosave --recursive "$@" \
    && pacman-clear
}

# Upgrade all packages
pacman-upgrade() {
  # PackageKit support
  if command -v pkcon > /dev/null 2> /dev/null; then
    sudo pkcon refresh && sudo pkcon update
  fi

  sudo pacman --sync --refresh --sysupgrade \
    && pacman-clear
}
