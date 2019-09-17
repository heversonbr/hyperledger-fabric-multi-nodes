# Creates/Enrolls the Peer's identity + Sets up MSP for peer
# Script needs to be executed for the peers setup
# PS: Since Register (step 1) can happen only once - ignore register error if you run script multiple times
# NOTE: The identity performing the register request must be currently enrolled

usage(){
    echo "------------------------------------------------------------------------"
    echo "USAGE: ./10_peer_register.sh <peer_name> <peer_pw> <org_name>"
    echo "   ex: ./10_peer_register.sh peer1 pw org1"
    echo "   ex: ./10_peer_register.sh peer2 pw org1"
    echo "   ex: ./10_peer_register.sh peer1 pw org2"
    echo "   ex: ./10_peer_register.sh peer2 pw org2"
    echo "------------------------------------------------------------------------"
    exit
}

if [ $# -ne 3 ]; then
    usage
fi

PEER_NAME=$1
PEER_PW=$2
ORG_NAME=$3
NEW_USER_AFFILIATION=$4  #acme.logistics

TYPE=peer
CA_SERVER_HOST_IP=192.168.1.10

# Identity of the peer must be created by the admin from the organization
IDENTITY="admin"

# sets the FABRIC_CA_CLIENT_HOME 
echo "current FABRIC_CA_CLIENT_HOME= $FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME="$BASE_FABRIC_CA_CLIENT_HOME/$ORG_NAME/$IDENTITY"
echo "now FABRIC_CA_CLIENT_HOME= $CA_CLIENT_FOLDER"



# Step-1  Org admin registers the identity
echo "#####################################################"
echo "# Registering peer $PEER_NAME with $ORG_NAME-admin"
echo "#####################################################"
echo "using FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME to register: "
echo "fabric-ca-client register --id.type $TYPE --id.name $PEER_NAME --id.secret $PEER_PW --id.affiliation $ORG_NAME "
fabric-ca-client register --id.type $TYPE --id.name $PEER_NAME --id.secret $PEER_PW --id.affiliation $ORG_NAME 
# NOTE: shouldn't we use the attributes here? :  --id.attrs $ATTRIBUTES   with ATTRIBUTES='"hf.Registrar.Roles=peer"'
echo "======Completed: Step 1 : Registered peer (can be done only once)===="
