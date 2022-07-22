#!/bin/bash

#####################################################################################################
# 	Filename:		.../dotfiles/install.sh															#
#	Purpose:		File that create the links for the opportune scripts into the opportune paths	#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com> 						#
#	License:		This file is licensed under the LGPLv3.											#
#	Pre-requisites:																					#
#					* sudo																			#
#####################################################################################################

__install() {
	local repo_path

	if ! command -v sudo &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	if ! repo_path="$(find "${HOME}" -type d -regex '.*/dotfiles' 2> /dev/null)"; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}find crashed${reset:-}" > /dev/stderr
		return 2
	fi

	if [[ "${SHELL}" == '/bin/bash' ]]; then
		ln --force --symbolic "${repo_path}/.bashrc" "${HOME}/.bashrc"
		sudo ln --force --symbolic "${repo_path}/.bashrc" '/root/.bashrc'
	elif [[ "${SHELL}" == '/bin/zsh' ]]; then
		ln --force --symbolic "${repo_path}/.zshrc" "${HOME}/.zshrc"
		sudo ln --force --symbolic "${repo_path}/.zshrc" '/root/.zshrc'
	fi

	if [[ -d "${HOME}/.vim" ]]; then
		rm --recursive --force "${HOME}/.vim"
	fi

	if [[ -d '/root/.vim' ]]; then
		sudo rm --recursive --force '/root/.vim'
	fi

	ln --force --symbolic "${repo_path}/.vimrc" "${HOME}/.vimrc"
	sudo ln --force --symbolic "${repo_path}/.vimrc" '/root/.vimrc'

	ln --force --symbolic "${repo_path}/.vim" "${HOME}/.vim"
	sudo ln --force --symbolic "${repo_path}/.vim" '/root/.vim'

	ln --force --symbolic "${repo_path}/.gitconfig" "${HOME}/.gitconfig"
	sudo ln --force --symbolic "${repo_path}/.gitconfig" '/root/.gitconfig'

	for i in "${repo_path}/.config/"*; do
		if [[ ! -d "${i}" ]]; then
			continue
		fi

		if [[ -d "${HOME}/.config/${i}" ]]; then
			rm --recursive --force "${HOME}/.config/${i}"
		fi

		if [[ -d "/root/.config/${i}" ]]; then
			sudo rm --recursive --force "/root/.config/${i}"
		fi

		ln --force --symbolic "${repo_path}/.config/${i}" "${HOME}/.config/${i}"
		sudo ln --force --symbolic "${repo_path}/.config/${i}" "/root/.config/${i}"
	done

	for i in "${repo_path}/desktop_entries/"*; do
		if [[ ! -f "${i}" ]]; then
			continue
		fi

		cp "${repo_path}/desktop_entries/${i}" "${HOME}/Desktop/${i}"
	done

	sudo ln --force --symbolic "${repo_path}/usr/share/xournalpp/ui/toolbar.ini" '/usr/share/xournalpp/ui/toolbar.ini'
}

__install
