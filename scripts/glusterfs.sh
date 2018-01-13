#!/bin/bash

############################################################################################################################
#
#                                    Configure NAS servers with glusterfs.
#
############################################################################################################################

. tools.sh

servs=(1 2 3)

send nas1 "
    sudo apt-get install glusterfs-{common,server,client} > /dev/null && echo Glusterfs installed;
"

section "Probing peers"
send nas1 "
    gluster peer probe nas${servs[0]};
    gluster peer probe nas${servs[1]};
    gluster peer probe nas${servs[2]};
"

section "Status of peers"
send nas1 "
    gluster peer status;
"

section "Create and start volume"
send nas1 "
    gluster volume create nas replica 3 nas${servs[0]}:/nas nas${servs[1]}:/nas nas${servs[2]}:/nas force;
    gluster volume start nas;
    gluster volume set nas network.ping-timeout 5;
"

section "Volume info"
send nas1 "
    gluster volume info;
"

section "Mounting glusterfs in CRM servers"
for item in ${servs[*]}
do
    send s$item "
         mkdir /mnt/nas;
         mount -t glusterfs nas1:/nas /mnt/nas && echo Done;
         echo ;
    "
done
