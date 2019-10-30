#!/bin/bash
#TODO: to be finished

usage(){
    echo "--------------------------------------------------------------------------------------"
    echo "Description: Copy the msp dir (org-admin certif. and ca-root certif.)" 
    echo "             from the admin of the organization passed as an argument"
    echo "--------------------------------------------------------------------------------------"
    echo "USAGE: ./05_get_org-pub-certs.sh <org_name> [admin_HOSTNAME , default=msp-admin-ORG_NAME]"
    echo "   EX: ./05_get_org-pub-certs.sh    org1    [msp-admin-org1] "
    echo "   EX: ./05_get_org-pub-certs.sh    org2    [msp-admin-org2] "
    echo "   EX: ./05_get_org-pub-certs.sh orderer [msp-admin-orderer] "
    echo "--------------------------------------------------------------------------------------"
    exit
}

if [ -z $1 ]
then
    usage
    exit 1
else 
    ORG_NAME=$1
fi
echo "=> Using ORG_NAME: $ORG_NAME"

if [ -z $2 ]
then
    ORG_HOSTNAME="msp-admin-$ORG_NAME"
else 
    ORG_HOSTNAME=$2
fi
echo "=> Using ORG_HOSTNAME: $ORG_HOSTNAME"
################################################################################################
ORIGIN_CERTS_DIR=$BASE_FABRIC_CA_CLIENT_HOME/$ORG_NAME/msp
LOCAL_DESTINATION=$BASE_FABRIC_CA_CLIENT_HOME/$ORG_NAME/msp
mkdir -p $LOCAL_DESTINATION 
################################################################################################
echo "----------------------------------------------------------------"
echo "Getting admin certs with SCP"
echo "scp -r $ORG_HOSTNAME:$ORIGIN_CERTS_DIR/  $LOCAL_DESTINATION"
echo "----------------------------------------------------------------"
scp -r $ORG_HOSTNAME:$ORIGIN_CERTS_DIR/*  $LOCAL_DESTINATION
echo "----------------------------------------------------------------"
echo "Done."