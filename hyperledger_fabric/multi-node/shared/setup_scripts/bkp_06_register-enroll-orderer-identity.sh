# Creates/Enrolls the Orderer's identity + Sets up MSP for orderer
# Script may executed multiple times 
# Similar to the register/enroll made for the orderer admin, but in this case the orderer admin is registering 
# and enrolling an identity of type orderer which is not the admin itself but it is the orderer node.

# Identity of the orderer will be created by the admin from the orderer organization
# NOTE: The identity performing the register request must be currently enrolled

CA_SERVER_HOST=192.168.1.10


# sets the FABRIC_CA_CLIENT_HOME to the orderer admin
IDENTITY="admin"
ORG_NAME="orderer"


SOURCE_CA_CLIENT_CONFIG_FILE="$BASE_CONFIG_FILES/fabric-ca-client-config-orderer-node.yaml"

#CA_CLIENT_FOLDER="$FABRIC_CA_CLIENT_HOME/orderer"

ADMIN_CLIENT_HOME=$BASE_FABRIC_CA_CLIENT_HOME/$ORG_NAME/$IDENTITY

echo "my FABRIC_CA_CLIENT_HOME: $FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME="$ADMIN_CLIENT_HOME"
echo "now FABRIC_CA_CLIENT_HOME: $FABRIC_CA_CLIENT_HOME"


# ----------------------------------------------------------
# Step-1  Orderer Admin Registers the orderer identity
# NOTE: The identity performing the register request must be currently enrolle
echo "##################################################"
echo "# Registering orderer identity with orderer-admin "
echo "##################################################"
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
echo "Registering :=> fabric-ca-client register --id.type orderer --id.name orderer --id.secret pw --id.affiliation orderer "
fabric-ca-client register --id.type orderer --id.name orderer --id.secret pw --id.affiliation orderer 
echo "======Completed: Step 1 : Registered orderer (can be done only once)===="

# ----------------------------------------------------------
# Step-2 Copy the client config yaml file
# Set the FABRIC_CA_CLIENT_HOME for orderer

IDENTITY="orderer"
echo "changing identity to [$IDENTITY]"
CA_CLIENT_FOLDER="$BASE_FABRIC_CA_CLIENT_HOME/$ORG_NAME/$IDENTITY"

echo "my FABRIC_CA_CLIENT_HOME: $FABRIC_CA_CLIENT_HOME"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER"
echo "now FABRIC_CA_CLIENT_HOME: $FABRIC_CA_CLIENT_HOME"

# Copy the client config yaml file
if [ -f "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE" ]; then 
    echo "Using $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE for $ORG_NAME / $IDENTITY"
else
    echo "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE not found in $FABRIC_CA_CLIENT_HOME/"
    echo "creating : mkdir -p $FABRIC_CA_CLIENT_HOME " 
    mkdir -p $FABRIC_CA_CLIENT_HOME

    echo "Copy Yaml from: $SOURCE_CA_CLIENT_CONFIG_FILE"
    echo "cp $SOURCE_CA_CLIENT_CONFIG_FILE  $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE"
    cp $SOURCE_CA_CLIENT_CONFIG_FILE $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE

    echo "checking with: ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE"
    ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE
    if [ `echo $?` = 0 ]; then 
        echo "File $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE found."; 
    else 
        echo "ERROR: file $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG_FILE not found!";
        exit 
    fi
fi
echo "======Completed: Step 2 : Copy Check Orderer Client YAML=========="

# ----------------------------------------------------------
# Step-3 Admin Orderer is enrolled
# Admin will  enroll the orderer identity. 
# The MSP will be written in the FABRIC_CA_CLIENT_HOME
# which was set to" FABRIC_CA_CLIENT_HOME/orderer/orderer" at lines 41-43
echo "###################################"
echo "# Enrolling: orderer"
echo "###################################"
echo "enrolling :=> fabric-ca-client enroll -u http://orderer:pw@$:$CA_SERVER_HOST:7054"
fabric-ca-client enroll -u http://orderer:pw@$CA_SERVER_HOST:7054
echo "======Completed: Step 3 : Enrolled orderer ========"

# ----------------------------------------------------------
echo "###################################"
echo "# Setting up admincerts folder"
echo "###################################"
# Step-4 Copy the admincerts to the appropriate folder
# NOTE: $FABRIC_CA_CLIENT_HOME/orderer/orderer
# NOTE: $ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/orderer/admin 
# at this point FABRIC_CA_CLIENT_HOME and CA_CLIENT_FOLDER must be the same
echo "DEBUG-ONLY: $FABRIC_CA_CLIENT_HOME == $CA_CLIENT_FOLDER ???"
echo "mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts"
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "cp $ADMIN_CLIENT_HOME/msp/signcerts/* $FABRIC_CA_CLIENT_HOME/msp/admincerts"
cp $ADMIN_CLIENT_HOME/msp/signcerts/* $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "checking with: ls $FABRIC_CA_CLIENT_HOME/msp/admincerts"
ls $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "======Completed: Step 4 : MSP setup for the orderer========"
