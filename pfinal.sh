#!/bin/bash
if (( $# != 1 )); then
    echo Wrong number of arguments
elif [ "$1" == "create" ]; then
    echo '*********************************************************************************'
    echo Creating network and containers.
    echo '*********************************************************************************'
    echo 
    sudo vnx -f ../pfinal/pfinal.xml --create > /dev/null && echo All machines are up and running
    echo 
    sleep 0.2

    PATH=$(pwd)/scripts:$PATH
    firewall.sh
    glusterfs.sh
elif [ "$1" == "destroy" ]; then
    echo '*********************************************************************************'
    echo Destroying network and containers.
    echo '*********************************************************************************'
    echo 
    sudo vnx -f ../pfinal/pfinal.xml --destroy > /dev/null && echo The network and the machines have been destoryed succesfully
    echo 
fi
