#!/bin/bash

servs=(1 2 3)

sudo lxc-attach --clear-env -n nas1 -- bash -c "
    echo '*********************************************************************************';
    echo Configure nas servers;
    echo '*********************************************************************************';
    echo ;

    sudo apt-get install glusterfs-{common,server,client} > /dev/null && echo Glusterfs installed;

    echo ;
    echo -----------------------------------------------;
    echo Probing peers;
    echo -----------------------------------------------;
    echo ;
    gluster peer probe 10.1.4.2${servs[0]};
    gluster peer probe 10.1.4.2${servs[1]};
    gluster peer probe 10.1.4.2${servs[2]};

    echo ;
    echo -----------------------------------------------;
    echo Status os peers;
    echo -----------------------------------------------;
    echo ;
    gluster peer status;

    echo ;
    echo -----------------------------------------------;
    echo Create and start volume;
    echo -----------------------------------------------;
    echo ;
    gluster volume create nas replica 3 10.1.4.2${servs[0]}:/nas 10.1.4.2${servs[1]}:/nas 10.1.4.2${servs[2]}:/nas force;
    gluster volume start nas;
    gluster volume set nas network.ping-timeout 5;

    echo ;
    echo -----------------------------------------------;
    echo Volume info;
    echo -----------------------------------------------;
    echo ;
    gluster volume info;
"

for item in ${servs[*]}
do
sudo lxc-attach --clear-env -n s$item -- bash -c "
    echo -----------------------------------------------;
    echo Mounting glusterfs in CRM servers
    echo -----------------------------------------------;
    echo ;
    echo Mount nas servers in s$item...;    
    mkdir /mnt/nas;
    mount -t glusterfs 10.1.4.21:/nas /mnt/nas && echo Done;
    echo ;
"
done
