#!/bin/bash

############################################################################################################################
#
#                                               Configure bbdd.
#
############################################################################################################################

. tools.sh

pass="'xxxx'"
host="'10.1.4.31'"

section "Updating and installing postgres"
send bbdd "
	apt-get update > /dev/null && echo Database server up to date;
	apt-get -y install postgresql &> /dev/null && echo Postgres installed;
"

section "Configuring postgres"
send bbdd "
	echo \"listen_addresses=$host\" >> /etc/postgresql/9.6/main/postgresql.conf;
	echo 'host all all 10.1.4.0/24 trust' >> /etc/postgresql/9.6/main/pg_hba.conf;
	echo \"CREATE USER crm with PASSWORD $pass;\" | sudo -u postgres psql; 
	echo 'CREATE DATABASE crm;' | sudo -u postgres psql;
	echo 'GRANT ALL PRIVILEGES ON DATABASE crm to crm;' | sudo -u postgres psql;
	systemctl restart postgresql;
"
echo
