#!/bin/bash

echo '*********************************************************************************';
echo Configuring firewall;
echo '*********************************************************************************';
echo ;
sudo cp $(pwd)/files/fw.fw /var/lib/lxc/fw/rootfs/root/
sudo lxc-attach --clear-env -n fw -- bash -c "sudo /root/fw.fw"
echo ;
