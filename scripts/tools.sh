#!/bin/bash

# Prints a title. For homogeneous output
function title {
	echo '*********************************************************************************'
	echo "		$1"
	echo '*********************************************************************************'
	echo 
}

# Prints a title of a section. For homogeneous output
function section {
	echo 
	echo -----------------------------------------------
	echo "	$1"
	echo -----------------------------------------------
	echo 
}

# Sends a series of commands to a container
function send {
	sudo lxc-attach --clear-env -n $1 -- bash -c "$2"
}
