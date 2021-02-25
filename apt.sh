#!/bin/sh

function apt-clear {
	sudo apt autoclean; sudo apt autoremove; sudo apt clean all
}

function apt-remove {
	# the parameter $* is the list of package that you want remove
	sudo apt purge $* && apt-clear
}

function apt-upgrade {
	# if the OS have KDE as DE (desktop enviroment), I suggest you to add, previous "sudo apt dist-upgrade" the string "sudo pkcon refresh; sudo pkcon update; "
	# if the configuration files are for the Termux's app, you must erease the keyword "sudo "

	sudo apt dist-upgrade; sudo apt full-upgrade; sudo apt update; sudo apt upgrade; apt-clear
}
