#!/bin/bash

############################################################################################################################
#
#									 Configure CRM servers 
#
############################################################################################################################

. scripts/tools.sh

servs=(s1 s2 s3)

section "Installing nodejs and CRM"
for item in ${servs[*]}
do
	echo "	$item";
	echo "------------------";
	send $item "
		cd /root;
		echo Getting nodejs...;
		curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - &> /dev/null && echo System updated and repository installed || echo Error installing node repository; 
		sudo apt-get -y install nodejs > /dev/null && echo Node installed;
		echo ;

		echo Getting CRM...;
		git clone https://github.com/CORE-UPM/CRM_2017.git &> /dev/null && echo CRM downloaded;
		cd CRM_2017;
		npm install;
		npm install forever &> /dev/null;
		echo ;
	"
done

section "Configuring storage (NAS and DB)"
for item in ${servs[*]}
do
	echo "	$item";
	echo "------------------";
	send $item "
		cd /root/CRM_2017;
		mkdir public;
		ln -s /mnt/nas public/upload;

	"
done
