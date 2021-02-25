#!/bin/sh

function pacman-clear {
	#sudo pacman autoclean; sudo pacman autoremove; sudo pacman clean all
}

function pacman-remove {
	# the parameter $* is the list of package that you want remove
	#sudo pacman purge $* && pacman-clear
}

function pacman-upgrade {
	# if the OS have KDE as DE (desktop enviroment), I suggest you to add, previous "sudo pacman dist-upgrade" the string "sudo pkcon refresh; sudo pkcon update; "

	#sudo pacman dist-upgrade; sudo pacman full-upgrade; sudo pacman update; sudo pacman upgrade; pacman-clear
}
