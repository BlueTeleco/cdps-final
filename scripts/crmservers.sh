#!/bin/bash

############################################################################################################################
#
#									 Configure CRM servers 
#
############################################################################################################################

. tools.sh

servs=(s1 s2 s3)
user="crm"
pass="xxxx"
dbhost=10.1.4.31
dbport=5432

if [ "$1" == "s4" ]; then
	servs+=(s4)
fi

section "Installing nodejs and CRM"
for item in ${servs[*]}
do
	echo "	$item";
	echo "------------------";
	send $item "
		cd /root;
		echo Getting nodejs...;
		curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - &> /dev/null && echo System updated and repository installed || echo Error installing node repository; 
		sudo apt-get -y install nodejs &> /dev/null && echo -n Installed Node-;
		nodejs --version;
		echo ;

		echo Getting CRM...;
		git clone https://github.com/CORE-UPM/CRM_2017.git &> /dev/null && echo CRM downloaded;
		cd CRM_2017;
		export DATABASE_URL=postgres://$user:$pass@$dbhost:$dbport/crm;
		npm install;
		npm install forever &> /dev/null;
		echo ;
	"
done

for item in ${servs[*]}
do
	send $item "
		cd /root/CRM_2017;
		mkdir public 2> /dev/null;
		ln -s /mnt/nas public/uploads;
	"
done

section "Migrating and seeding database"
send s1 "
	cd /root/CRM_2017;
	export DATABASE_URL=postgres://$user:$pass@$dbhost:$dbport/crm;
	npm run-script migrate_local > /dev/null && echo Succesfully migrated database;
	npm run-script seed_local > /dev/null && echo Succesfully seeded database;
"

section "Starting servers"
for item in ${servs[*]}
do
	echo ;
	echo "	$item";
	echo "------------------";
	send $item "
		cd /root/CRM_2017;
		export DATABASE_URL=postgres://$user:$pass@$dbhost:$dbport/crm;
		./node_modules/forever/bin/forever start ./bin/www
	"
done
echo
