#!/bin/bash

############################################################################################################################
#
#									 Configure nagios server
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
		wget https://raw.githubusercontent.com/BlueTeleco/cdps-final/master/files/s$n_nagios.cfg -P /etc/nagios3/conf.d
	"
done

# Modificamos hostgroups
send nagios "
	lxc-attach -n nagios -- rm -rf /etc/nagios3/conf.d/hostgroups.cfg
    lxc-attach -n nagios -- wget https://raw.githubusercontent.com/BlueTeleco/cdps-final/master/files/hostgroups.cfg -P /etc/nagios3/conf.d/hosts.cfg

"

# Reinicio
section "Restarting services"
send nagios "
	service nagios3 restart;
	service apache2 restart;
"
