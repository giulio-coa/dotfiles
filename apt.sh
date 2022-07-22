#!/bin/bash

#################################################################################
#	Filename:		.../dotfiles/apt.sh											#
#	Purpose:		File that manage the package manager apt					#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.						#
#	Pre-requisites:																#
#					* sudo														#
#################################################################################

# Clear un-needed dipendecies
apt-clear() {
	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	sudo apt autoremove
	sudo apt clean all
}

# Remove packages, their dependencies not required and configurations
apt-remove() {
	# the parameter $* is the list of package that you want remove

	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	sudo apt purge "$*" && apt-clear
}

# Upgrade all packages
apt-upgrade() {
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

	sudo apt update
	sudo apt dist-upgrade
	sudo apt full-upgrade
	apt-clear
}
