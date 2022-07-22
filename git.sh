#!/bin/bash

#################################################################################
#	Filename:		.../dotfiles/git.sh											#
#	Purpose:		File that manage git										#
#	Authors:		Giulio Coa <34110430+giulioc008@users.noreply.github.com>	#
#	License:		This file is licensed under the LGPLv3.						#
#	Pre-requisites:																#
#					* git														#
#################################################################################

# Update a single repository
__pull_repository() {
	# the parameter $1 is the name of the branch

	local base_branch branch_name

	if ! command -v git &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}git isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	# On Alpine Linux, some commands are installed in a reduced version
	if command -v apk &> /dev/null; then
		if ! command -v sudo &> /dev/null; then
			# shellcheck disable=SC3037
			echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
			return 1
		fi

		sudo apk --quiet --no-cache add grep sed
	fi

	base_branch="$(git branch --list | \
		grep --no-messages --extended-regexp --regexp='^\*' | \
		sed --regexp-extended --expression='s/^\* //')"

	# check if the program must update all the branches
	if [[ "$#" -eq 0 ]]; then
		for i in $(git branch --list | \
				sed --regexp-extended --expression='s/^(.*)\*\s*(.*)$/\1\2/'); do
			branch_name="$(sed --regexp-extended --expression='s/^\s*//' --expression='s/\s*$//' <<< "${i}")"

			git checkout "${branch_name}" &> /dev/null

			git pull --verbose --recurse-submodules=yes --all --prune
		done
	# check if the program must update only one branch
	elif [[ "$#" -eq 1 ]]; then
		git checkout "$1" &> /dev/null && \
			git pull --verbose --recurse-submodules=yes --all --prune
	else
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}Too much parameters for the function __pull_repository().${reset:-}" > /dev/stderr
		return 5
	fi

	git checkout "${base_branch}" &> /dev/null
}

# Update the repositories
git-update() {
	local __REPO branch
	local options

	if ! command -v git &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}git isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	# set the flag to update only one repository
	__REPO=0
	# set the flag to update only one branch
	branch=''

	if ! options="$(getopt --name "$0" --options 'ab:h' --longoptions 'all,branch:,help'  -- "$@")"; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}getopt command has failed.${reset:-}" > /dev/stderr
		return 2
	fi

	eval set -- "${options}"

	while true; do
		case "$1" in
			-a | --all)
				__REPO=1

				shift
				continue
				;;
			-b | --branch)
				branch="$2"

				shift 2
				continue
				;;
			-h | --help)
				printf 'git-update [options]\n\n'
				printf 'Options:\n'
				printf '\t-a, --all: Do the pull of all your local repo\n'
				printf '\t-b <branch_name>, --branch <branch_name>: Do the pull only of the specified branch\n'
				printf '\t-h, --help: Print this menu\n'
				return 0
				;;
			--)
				shift
				break
				;;
			*)
				# shellcheck disable=SC3037
				echo -e "${bold_red:-}Internal error.${reset:-}" > /dev/stderr
				return 3
				;;
		esac
	done

	# check if the program must update only one repository
	if [[ "${__REPO}" -eq 0 ]]; then
		git fetch --all --prune --verbose

		# check if the program must update all the branches
		if [[ -z "${branch}" ]]; then
			__pull_repository
		else
			__pull_repository "${branch}"
		fi
	else
		for i in path/that/contains/all/your/repository/*/; do
			if [[ ! -d "${i}" ]]; then
				continue
			fi

			(
				cd "${i}" || return 4

				git fetch --all --prune --verbose

				# check if the program must update all the branches of all the repositories
				if [[ -z "${branch}" ]]; then
					__pull_repository
				else
					__pull_repository "${branch}"
				fi
			)
		done
	fi
}

# Commit a single repository
__commit_repository() {
	# the parameter $1 is the message of the commit

	local base_branch branch_name

	if ! command -v git &> /dev/null; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}git isn't installed${reset:-}" > /dev/stderr
		return 1
	fi

	# On Alpine Linux, some commands are installed in a reduced version
	if command -v apk &> /dev/null; then
		if ! command -v sudo &> /dev/null; then
			# shellcheck disable=SC3037
			echo -e "${bold_red:-}sudo isn't installed${reset:-}" > /dev/stderr
			return 1
		fi

		sudo apk --quiet --no-cache add grep sed
	fi

	base_branch="$(git branch --list | \
		grep --no-messages --extended-regexp --regexp='^\*' | \
		sed --regexp-extended --expression='s/^\* //')"

	if [[ "$#" -eq 0 ]]; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}Too less parameters for the function __commit_repository().${reset:-}" > /dev/stderr
		return 5
	# check if the program must commit only one branch
	elif [[ "$#" -eq 1 ]]; then
		git add --verbose --interactive -- .
		git commit --all --signoff --verbose --message="${1}"
		git push --verbose
	# check if the program must commit all the branches
	elif [[ "$#" -eq 2 ]]; then
		for i in $(git branch --list | \
				sed --regexp-extended --expression='s/^(.*)\*\s*(.*)$/\1\2/'); do
			branch_name="$(sed --regexp-extended --expression='s/^\s*//' --expression='s/\s*$//' <<< "${i}")"

			git checkout "${branch_name}" &> /dev/null

			git add --verbose --interactive -- .
			git commit --all --signoff --verbose --message="${1}"
			git push --verbose
		done
	else
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}Too much parameters for the function __commit_repository().${reset:-}" > /dev/stderr
		return 6
	fi

	git checkout "${base_branch}" &> /dev/null
}

# Commit the repositories
git-commit() {
	local __REPO __BRANCH message
	local options

	# set the flag to update only one repository
	__REPO=0
	# set the flag to update only one branch
	__BRANCH=0
	message='Automatic commit of the repository'

	if ! options="$(getopt --name "$0" --options 'abhm::' --longoptions 'all-repo,all-branch,help,message::'  -- "$@")"; then
		# shellcheck disable=SC3037
		echo -e "${bold_red:-}getopt command has failed.${reset:-}" > /dev/stderr
		return 2
	fi

	eval set -- "${options}"

	while true; do
		case "$1" in
			-a | --all-repo)
				__REPO=1

				shift
				continue
				;;
			-b | --all-branch)
				__BRANCH=1

				shift
				continue
				;;
			-h | --help)
				printf 'git-commit [options]\n\n'
				printf 'Options:\n'
				printf '\t-a, --all-repo: Do the commit of all your local repo\n'
				printf '\t-b, --all-branch: Do the commit of all your local branch\n'
				printf '\t-h, --help: Print this menu\n'
				printf '\t-m <text>, --message <text>: Specify a message for the commit\n'
				return 0
				;;
			-m | --message)
				# -m and --message have an optional argument.
				# As we are in quoted mode, an empty parameter will be generated if
				# its optional argument is not found.
				case "$2" in
					'')
						;;
					*)
						message="$2"
						;;
				esac

				shift 2
				continue
				;;
			--)
				shift
				break
				;;
			*)
				# shellcheck disable=SC3037
				echo -e "${bold_red:-}Internal error.${reset:-}" > /dev/stderr
				return 3
				;;
		esac
	done

	# check if the program must update only one repository
	if [[ "${__REPO}" -eq 0 ]]; then
		# check if the program must update only one branch
		if [[ "${__BRANCH}" -eq 0 ]]; then
			__commit_repository "${message}"
		else
			__commit_repository "${message}" '-'
		fi
	else
		for i in path/that/contains/all/your/repository/*/; do
			if [[ ! -d "${i}" ]]; then
				continue
			fi

			(
				cd "${i}" || return 4

				# check if the program must update only one branch
				if [[ "${__BRANCH}" -eq 0 ]]; then
					__commit_repository "${message}"
				else
					__commit_repository "${message}" '-'
				fi
			)
		done
	fi
}
