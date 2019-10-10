#!/bin/bash
# TODO : remove localhost from the list  , remove this script!

ALLHOSTS="msp-root1-org1 msp-admin-org1 msp-admin-org2 orderer-node peer1-org1 peer2-org1"
REMOTE_USER=ubuntu

usage(){
    echo "-----------------------------------------------------------------------------"
    echo "USAGE: ./broadcast_cmd.sh <cmd>"
    echo "   ex: ./broadcast_cmd.sh  pwd"
    echo "------------------------------------------------------------------------------"
    exit
}

if [ $# -ne 1 ]; then
    usage
fi

CMD=$1

for host in $ALLHOSTS; do 
    echo "-----------------------------------" 
    echo "Broadcasting cmd to: $host"
    echo "-----------------------------------" 
    echo "ssh -o StrictHostKeyChecking=no $REMOTE_USER@$host \"$CMD\" "


done

echo "-----------------------------------" 
echo "Done.
echo "-----------------------------------" 