#!/bin/bash

PATH=$(pwd)/scripts:$PATH
. tools.sh

if (( $# != 1 )); then
    echo Wrong number of arguments
elif [ "$1" == "create" ]; then
    title 'Creating network and containers.'
    sudo vnx -f ../pfinal/pfinal.xml --create > /dev/null && echo All machines are up and running
    echo 
    sleep 0.5

    title 'Configuring firewall'
    firewall.sh

    title 'Configurig NAS servers'
    glusterfs.sh


elif [ "$1" == "destroy" ]; then
    title 'Destroying network and containers.'
    sudo vnx -f ../pfinal/pfinal.xml --destroy > /dev/null && echo The network and the machines have been destoryed succesfully
    echo 

elif [ "$1" == "shutdown" ]; then
    title 'Shutting down network and containers.'
    sudo vnx -f ../pfinal/pfinal.xml --shutdown > /dev/null && echo The network and the machines have been shutdown succesfully
    echo 

elif [ "$1" == "start" ]; then
    title 'Starting network and containers.'
    sudo vnx -f ../pfinal/pfinal.xml --start > /dev/null && echo The network and the machines have been started succesfully || echo There has been an error. Check that the machines have been created.
    echo 
fi
