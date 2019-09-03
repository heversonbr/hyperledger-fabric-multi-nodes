# Creates/Enrolls the Orderer's identity + Sets up MSP for orderer
# Script may executed multiple times 
# Similar to the register/enroll made for the orderer admin, but in this case the orderer admin is registering 
# and enrolling an identity of type orderer which is not the admin itself but it is the orderer node.

# Identity of the orderer will be created by the admin from the orderer organization


CA_SERVER_HOST=192.168.1.10

# sets the FABRIC_CA_CLIENT_HOME to the orderer admin
IDENTITY="admin"
CA_CLIENT_FOLDER="$FABRIC_CA_CLIENT_HOME/orderer"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME


# ----------------------------------------------------------
# Step-1  Orderer Admin Registers the orderer identity
echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
fabric-ca-client register --id.type orderer --id.name orderer --id.secret pw --id.affiliation orderer 
echo "======Completed: Step 1 : Registered orderer (can be done only once)===="

# ----------------------------------------------------------
# Step-2 Copy the client config yaml file
# Set the FABRIC_CA_CLIENT_HOME for orderer
IDENTITY="orderer"
CA_CLIENT_FOLDER="$FABRIC_CA_CLIENT_HOME/orderer"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"

# Copy the client config yaml file
# If client YAML not found then copy the client YAML before enrolling
SOURCE_CONFIG_CLIENT_YAML="$FABRIC_CONFIG_FILES/fabric-ca-client-config-orderer-identity.yaml"

if [ -f "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG" ]; then 
    echo "Using the existing Client $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG for $ORG_NAME admin"
else
    echo "$FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG not found in $FABRIC_CA_CLIENT_HOME/"
    echo "creating : mkdir -p $FABRIC_CA_CLIENT_HOME " 
    mkdir -p $FABRIC_CA_CLIENT_HOME

    echo "Copy the Client Yaml from $SOURCE_CONFIG_CLIENT_YAML"
    echo "cp $SOURCE_CONFIG_CLIENT_YAML $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG"
    cp $SOURCE_CONFIG_CLIENT_YAML $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG

    echo "checking with: ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG"
    ls $FABRIC_CA_CLIENT_HOME/$FABRIC_CA_CLIENT_CONFIG
fi
echo "======Completed: Step 2 : Copy Check Orderer Client YAML=========="

# ----------------------------------------------------------
# Step-3 Admin Orderer is enrolled
# Admin will  enroll the orderer identity. 
# The MSP will be written in the FABRIC_CA_CLIENT_HOME
# which was set to" FABRIC_CA_CLIENT_HOME/orderer/orderer" at lines 41-43

fabric-ca-client enroll -u http://orderer:pw@CA_SERVER_HOST:7054
echo "======Completed: Step 3 : Enrolled orderer ========"

# ----------------------------------------------------------
# Step-4 Copy the admincerts to the appropriate folder
# NOTE: $FABRIC_CA_CLIENT_HOME/orderer/orderer
# NOTE: $ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME/orderer/admin 
echo "mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts"
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "cp $ADMIN_CLIENT_HOME/msp/signcerts/* $FABRIC_CA_CLIENT_HOME/msp/admincerts"
cp $ADMIN_CLIENT_HOME/msp/signcerts/* $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "checking with: ls $FABRIC_CA_CLIENT_HOME/msp/admincerts"
ls $FABRIC_CA_CLIENT_HOME/msp/admincerts
echo "======Completed: Step 4 : MSP setup for the orderer========"
