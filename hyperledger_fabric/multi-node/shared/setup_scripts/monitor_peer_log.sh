#!/bin/bash

function usage {
    echo 'USAGE:  . ./monitor_peer_log.sh  <ORG_NAME> <PEER_NAME>'
    exit 0
}

if [ -z $1 ]; then
    echo "Inform ORG name!!!"
    usage
else
    ORG_NAME=$1
fi

if [ -z $2 ]; then
    echo "Inform PEER name!!!"
    usage
else
    PEER_NAME=$2
fi


tail -f /home/ubuntu/hyperledger_ws/fabric/$ORG_NAME/$PEER_NAME/peer.log