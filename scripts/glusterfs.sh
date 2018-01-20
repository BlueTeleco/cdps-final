#!/bin/bash

############################################################################################################################
#
#									 Configure NAS servers with glusterfs.
#
############################################################################################################################

. tools.sh

servs=(1 2 3)

send nas1 "
	sudo apt-get install glusterfs-{common,server,client} > /dev/null && echo Glusterfs installed;
"

section "Probing peers"
for n in ${servs[*]}
do
	send nas1 "
		gluster peer probe nas$n;
	"
done

section "Status of peers"
send nas1 "
	gluster peer status;
"

section "Create and start volume"
nas=""
for n in ${servs[*]}
do
	nas="$nas nas$n:/nas"
done
send nas1 "
	gluster volume create nas replica ${#servs[*]} $nas force;
	gluster volume start nas;
	gluster volume set nas network.ping-timeout 5;
"

section "Volume info"
send nas1 "
	gluster volume info;
"

section "Mounting glusterfs in CRM servers"
for n in ${servs[*]}
do
	send s$n "
		 mkdir /mnt/nas;
		 mount -t glusterfs nas1:/nas /mnt/nas && echo s$n done;
		 echo ;
	"
done
