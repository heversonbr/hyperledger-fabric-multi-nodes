# Creates/Enrolls the Peer's identity + Sets up MSP for peer
# Script needs to be executed for the peers setup
# PS: Since Register (step 1) can happen only once - ignore register error if you run script multiple times
# NOTE: The identity performing the register request must be currently enrolled

usage(){
    echo "------------------------------------------------------------------------"
    echo "USAGE: ./14_peer_enroll.sh <peer_name> <peer_pw> <org_name> <org-admin_HOSTNAME>"
    echo "   ex: ./14_peer_enroll.sh peer1 pw org1 msp-admin-org1"
    echo "   ex: ./14_peer_enroll.sh peer2 pw org1 msp-admin-org1"
    echo "   ex: ./14_peer_enroll.sh peer1 pw org2 msp-admin-org2"
    echo "   ex: ./14_peer_enroll.sh peer2 pw org2 msp-admin-org2"
    echo "------------------------------------------------------------------------"
    exit
}

if [ $# -ne 4 ]; then
    usage
fi
################################################################################################
PEER_NAME=$1
PEER_PW=$2
ORG_NAME=$3
CA_ORG_ADMIN_HOSTNAME=$4  

TYPE=peer
CA_SERVER_HOST_IP=192.168.1.10

SOURCE_CONFIG_CLIENT_YAML="$BASE_CONFIG_FILES/fabric-ca-client-config-$PEER_NAME-$ORG_NAME.yaml"
################################################################################################

echo  "###############################################"
export ADMIN_CLIENT_HOME="$BASE_FABRIC_CA_CLIENT_HOME/$ORG_NAME/admin"
echo "ADMIN_CLIENT_HOME= $ADMIN_CLIENT_HOME"
echo  "###############################################"

# Set the FABRIC_CA_CLIENT_HOME for peer
IDENTITY=$PEER_NAME

. ./set-ca-client.sh  $ORG_NAME $IDENTITY
echo "checking FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"

# previous without set-ca-client.sh:
# echo "setting identity to $IDENTITY"
# # set Fabric Ca Client Home
# echo "current FABRIC_CA_CLIENT_HOME= $FABRIC_CA_CLIENT_HOME"
# export FABRIC_CA_CLIENT_HOME="$BASE_FABRIC_CA_CLIENT_HOME/$ORG_NAME/$IDENTITY"
# echo "now FABRIC_CA_CLIENT_HOME= $FABRIC_CA_CLIENT_HOME"

################################################################################################
# Step-2 Copies the YAML file for CSR setup
if [ -f "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE" ]; then 
    echo "Using $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE for $ORG_NAME / $IDENTITY"
else
    echo "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE not found in $FABRIC_CA_CLIENT_HOME/"
    echo "creating : mkdir -p $FABRIC_CA_CLIENT_HOME " 
    mkdir -p $FABRIC_CA_CLIENT_HOME

    echo "Copy Yaml: $SOURCE_CONFIG_CLIENT_YAML"
    echo "cp $SOURCE_CONFIG_CLIENT_YAML  $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE"
    cp $SOURCE_CONFIG_CLIENT_YAML $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE

    echo "checking with: ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE"
    ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE
fi
echo "======Completed: Step 2 : Copy Check Orderer Client YAML=========="
################################################################################################
# Step-3 Peer identity is enrolled
# Admin will  enroll the peer identity. The MSP will be written in the 
# FABRIC_CA_CLIENT_HOME
echo "#####################################################"
echo "# Enrolling peer $PEER_NAME"
echo "#####################################################"
echo "enrolling with: fabric-ca-client enroll -u http://$PEER_NAME:$PEER_PW@$CA_SERVER_HOST_IP:7054"
fabric-ca-client enroll -u http://$PEER_NAME:$PEER_PW@$CA_SERVER_HOST_IP:7054
echo "======Completed: Step 3 : Enrolled $PEER_NAME ========"
echo " "
################################################################################################
# Step-4 Copy the admincerts to the appropriate folder
echo "#####################################################"
echo "# Setting up admincerts"
echo "#####################################################"
if [ ! -d  $FABRIC_CA_CLIENT_HOME/msp/admincerts ]; then 
    echo "Creating $FABRIC_CA_CLIENT_HOME/msp/admincerts"
    mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
else
    echo "$FABRIC_CA_CLIENT_HOME/msp/admincerts already exists!!!"
fi
echo "====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"
################################################################################################
#echo "Copying admincerts for user $IDENTITY from $ADMIN_CLIENT_HOME/msp/signcerts/ to  $FABRIC_CA_CLIENT_HOME/msp/admincerts"
#cp $ADMIN_CLIENT_HOME/msp/signcerts/*    $FABRIC_CA_CLIENT_HOME/msp/admincerts
#echo "======Completed: Step 4 : MSP setup for the peer========"

ADMIN_CERTS_DIR="$ADMIN_CLIENT_HOME/msp/signcerts"
echo "copying [$ADMIN_CERTS_DIR] from host [$CA_ORG_ADMIN_HOSTNAME] here at [$FABRIC_CA_CLIENT_HOME/msp/admincerts]"

echo "Getting admin certs with SCP"
echo "scp $CA_ORG_ADMIN_HOSTNAME:$ADMIN_CERTS_DIR/* $FABRIC_CA_CLIENT_HOME/msp/admincerts"
scp $CA_ORG_ADMIN_HOSTNAME:$ADMIN_CERTS_DIR/* $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "checking with: ls $FABRIC_CA_CLIENT_HOME/msp/admincerts/"

ls $FABRIC_CA_CLIENT_HOME/msp/admincerts/
if [ `echo $?` = 0 ]; then 
    echo "File(s) found at $FABRIC_CA_CLIENT_HOME/msp/admincerts/."; 
else 
    echo "File(s) NOT found at $FABRIC_CA_CLIENT_HOME/msp/admincerts/ !";
fi
################################################################################################
echo "Done."