#!/bin/bash

#################################################################################################
#	Filename:		.../dotfiles/aur.sh															#
#	Purpose:		File that manage the package manager AUR									#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>, Christian Mondo	#
#	License:		This file is licensed under the LGPLv3.										#
#	Pre-requisites:																				#
#					* sudo																		#
#					* yay (https://github.com/Jguer/yay)										#
#################################################################################################

# Clear unneeded dipendecies
aur-clear() {
	if ! command -v yay &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}yay isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	yay --yay --clean
}

# Install from AUR or repository
aur-install() {
	# the parameter $* is the list of package that you want install

	if ! command -v yay &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}yay isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	yay --sync "$*"
}

# List explicitly installed AUR packages
aur-list-installed() {
	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	sudo pacman --query --explicit --foreign
}

# List installed AUR packages
aur-list-installed-all() {
	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	sudo pacman --query --foreign
}

# Remove packages, their dependencies not required and configurations
aur-remove() {
	# the parameter $* is the list of package that you want remove

	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	sudo pacman --remove --nosave --recursive "$*" && aur-clear
}

# Upgrade all AUR packages
aur-upgrade() {
	if ! command -v yay &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}yay isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	# KDE as DE (desktop enviroment)
	if command -v pkcon &> /dev/null; then
		if ! command -v sudo &> /dev/null; then
			# shellcheck disable=SC3037
			echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
			return 1
		fi

		sudo pkcon refresh
		sudo pkcon update
	fi

	yay --sync --refresh --sysupgrade --aur
	aur-clear
}
