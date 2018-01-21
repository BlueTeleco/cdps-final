#!/bin/bash

############################################################################################################################
#
#	  Create, destroy, start or shutdown the vnx network. When creating configure the machines with their scripts.
#
############################################################################################################################

PATH=$(pwd)/scripts:$PATH
. tools.sh
args=""

if [ $# != 1 ]; then
	if [ "$2" == "--extra-server" ]; then
		cp files/pfinal.xml ../pfinal/
		args="s4"
	fi
fi

if  [ "$1" == "create" ]; then
	title 'Creating network and containers.'
	sudo vnx -f ../pfinal/pfinal.xml --create > /dev/null && echo All machines are up and running
	echo 
	sleep 5

	title "Configuring postgresql database"
	bbdd.sh

	title 'Configurig NAS servers'
	glusterfs.sh $args

	title 'Configuring CRM servers'
	crmservers.sh $args

	title 'Configuring load balancer'
	lb.sh $args

	title 'Configuring firewall'
	firewall.sh

elif [ "$1" == "destroy" ]; then
	title 'Destroying network and containers.'
	sudo vnx -f ../pfinal/pfinal.xml --destroy > /dev/null && echo The network and the machines have been destoryed succesfully
	echo 

elif [ "$1" == "shutdown" ]; then
	title 'Shutting down network and containers.'
	sudo vnx -f ../pfinal/pfinal.xml --shutdown > /dev/null && echo The network and the machines have been shutdown succesfully
	echo 

elif [ "$1" == "start" ]; then
	title 'Starting network and containers.'
	sudo vnx -f ../pfinal/pfinal.xml --start > /dev/null && echo The network and the machines have been started succesfully || echo There has been an error. Check that the machines have been created.
	echo 

elif [ "$1" == "help" ]; then
	title 'Help'
	section 'Usage'
	echo "pfinal <command>"
	
	section 'Commands'
	echo "	- create"
	echo "	- destroy"
	echo "	- start"
	echo "	- shutdown"
	echo "	- help"
	echo

else
	echo Wrong arguments. Check help for more information
fi
