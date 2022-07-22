#!/bin/bash

#################################################################################################
#	Filename:		.../dotfiles/pacman.sh														#
#	Purpose:		File that manage the package manager pacman									#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>, Christian Mondo	#
#	License:		This file is licensed under the LGPLv3.										#
#	Pre-requisites:																				#
#					* sudo																		#
#################################################################################################

# Remove all the cached packages that are not currently installed and the unused sync database
pacman-clear() {
	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	sudo pacman --sync --clean
}

# Remove all cached file
pacman-clear-all() {
	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	sudo pacman --sync --clean --clean
}

# Install list of packages without reinstall the already installed ones
pacman-install() {
	# the parameter $* is the list of package that you want install

	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	sudo pacman --sync --needed "$*"
}

# List explicitly installed packages
pacman-list-installed() {
	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	sudo pacman --query --explicit --native
}

# List installed packages
pacman-list-installed-all() {
	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	sudo pacman --query --native
}

# Remove packages, their dependencies not required and configurations
pacman-remove() {
	# the parameter $* is the list of package that you want remove

	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	sudo pacman --remove --nosave --recursive "$*" && pacman-clear
}

# Upgrade all packages
pacman-upgrade() {
	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	# KDE as DE (desktop enviroment)
	if command -v pkcon &> /dev/null; then
		sudo pkcon refresh
		sudo pkcon update
	fi

	sudo pacman --sync --refresh --sysupgrade
	pacman-clear
}
