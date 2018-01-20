#!/bin/bash

############################################################################################################################
#
#									 Configure load balancer
#
############################################################################################################################

. tools.sh

servs=(1 2 3)

# Instalacion para Nagios
section "Installing dependencies"
send nagios "
	apt-get update;
	apt-get install nano -y;
	apt-get install apache2 -y;
	apt-get install nagios3 -y;
	service apache2 restart;
"

# Obtenemos las config files para los servidores (por el momento he puesto los tres sin contar el cuarto de la mejora)
section "Getting config files for servers"
for n in ${servs[*]}
do
	send nagios "
		wget https://raw.githubusercontent.com/..../....../s$n_nagios2.cfg -P /etc/nagios3/conf.d
	"
done

# Modificamos uno que se encuentre en github FALTA SUBIRLO A GITHUB Y DESDE LA CARPETA QUE SE ENCUENTRE ANADIRLO ---ESTE APARTADO REPASAR---
send nagios "
	rm -rf /etc/nagios3/conf.d/hostgroups_nagios2.cfg;
	wget https://raw.githubusercontent.com/________________________ -P /etc/nagios3/conf.d/hosts.cfg
	wget https://raw.githubusercontent.com/________________________ -P /etc/nagios3/conf.d
"

# Reinicio
section "Restarting services"
send nagios "
	service nagios3 restart;
	service apache2 restart;
"
