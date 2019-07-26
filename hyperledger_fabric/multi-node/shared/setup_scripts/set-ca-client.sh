# Sets the FABRIC_CA_CLIENT_HOME based on (a) org (b) enrollment ID

function usage {
    echo    "USAGE: .  ./setclient.sh ORG-Name Enrollment-ID"
            "   ex: .  ./setclient.sh acme admin"
    echo "the . before ./ is required in order to source the file"        
    echo "FABRIC_CA_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME"
}

if [ -z $1 ];
then
    usage
    echo   "Provide ORG-Name & enrollment ID"
    exit 1
fi

if [ -z $2 ];
then
    usage
    echo   "Please provide enrollment ID"
    exit 1
fi

echo "current FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"
echo "received : [$1] and [$2]"
export FABRIC_CA_CLIENT_HOME=$HYPERLEDGER_HOME/ca-client/$1/$2
echo "now FABRIC_CA_CLIENT_HOME = $FABRIC_CA_CLIENT_HOME"

if [ "$0" = "./setclient.sh" ]
then
    echo "Did you use the . before ./setclient.sh? If yes then we are good :)"
fi

