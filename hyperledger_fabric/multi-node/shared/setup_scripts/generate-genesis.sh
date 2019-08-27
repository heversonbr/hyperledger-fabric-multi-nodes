# Generates the orderer | generate genesis block for a channel 
# #export ORDERER_GENERAL_LOGLEVEL=debug
# export FABRIC_LOGGING_SPEC=INFO
# export FABRIC_CFG_PATH=$PWD

PROFILE=AirlineOrdererGenesis
OUTBLOCK=./airline-genesis.block
CHANNELID=ordererchannel

# Create the Genesis Block
echo    '================ Writing the Genesis Block ================'

configtxgen -profile $PROFILE -outputBlock $OUTBLOCK -channelID $CHANNELID
# profile : the profile from configtx.yaml
# outputBlock : the path to write the genesis block
# channelID  :  channel ID to use in the configtx