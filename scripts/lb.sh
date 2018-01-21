#!/bin/bash

############################################################################################################################
#
#									 Configure load balancer
#
############################################################################################################################

servs=(1 2 3)

if [ "$1" == "s4" ]; then
	servs+=(4)
fi

back=""
for n in ${servs[*]}
do
	back="$back --backend 10.1.3.1$n:3000"
done

xterm -hold -e "sudo lxc-attach --clear-env -n lb -- xr --verbose --server tcp:0:80 -d lax-stored-ip:60 $back --web-interface 0:8001" &
echo 'Load balancer up and running'
echo
