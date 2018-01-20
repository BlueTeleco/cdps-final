#!/bin/bash

############################################################################################################################
#
#                                               Configure bbdd.
#
############################################################################################################################

. tools.sh

send bbdd "
	apt-get update;
	apt-get -y install postgresql;
	echo "listen_addresses='10.1.4.31'" >> /etc/postgresql/9.6/main/postgresql.conf;
	echo "host all all 10.1.4.0/24 trust" >> /etc/postgresql/9.6/main/pg_hba.conf;
	echo "CREATE USER crm with PASSWORD 'xxxx';" | sudo -u postgres psql;
	echo "CREATE DATABASE crm;" | sudo -u postgres psql;
	echo "GRANT ALL PRIVILEGES ON DATABASE crm to crm;" | sudo -u postgres psql;
	systemctl restart postgresql;
"

echo "DATABASE_URL=postgres://{user}:{password}@{hostname}:{port}/{database-name}
#Rellenar campos


