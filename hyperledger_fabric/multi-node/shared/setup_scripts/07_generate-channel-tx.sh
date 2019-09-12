# Generates the channel transaction

# # export ORDERER_GENERAL_LOGLEVEL=debug
# export FABRIC_LOGGING_SPEC=INFO
# export FABRIC_CFG_PATH=$PWD

# NOTE:
# The configtxgen tool has no sub-commands, but supports flags which can be set to accomplish a number of tasks.
# -profile string : The profile from configtx.yaml to use for generation. (default "SampleInsecureSolo")
# -outputCreateChannelTx string : The path to write a channel creation configtx to (if set)
# -channelID string :   The channel ID to use in the configtx

# this is important for all orderer related scripts (the base FABRIC_CFG_PATH=$HYPERLEDGER_HOME/fabric)
export FABRIC_CFG_PATH=$FABRIC_CFG_PATH/orderer

PROFILE=MyChannelProfile 
OUTPUT_CHANNEL=$FABRIC_CFG_PATH/my-channel.tx 
CHANNELID=mychannelid

echo    '================ Writing $CHANNELID ================'
configtxgen -profile $PROFILE -outputCreateChannelTx $OUTPUT_CHANNEL -channelID $CHANNELID
echo "you can use 'configtxgen -inspectChannelCreateTx  <$OUTPUT_CHANNEL>' to verifiy the generated channel "
echo    '======= Done. Launch by executing orderer ======'
