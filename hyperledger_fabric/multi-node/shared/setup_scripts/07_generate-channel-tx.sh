# Generates the orderer | generate the channel transaction

# # export ORDERER_GENERAL_LOGLEVEL=debug
# export FABRIC_LOGGING_SPEC=INFO
# export FABRIC_CFG_PATH=$PWD

# NOTE:
# The configtxgen tool has no sub-commands, but supports flags which can be set to accomplish a number of tasks.
# -profile string : The profile from configtx.yaml to use for generation. (default "SampleInsecureSolo")
# -outputCreateChannelTx string : The path to write a channel creation configtx to (if set)
# -channelID string :   The channel ID to use in the configtx

PROFILE=MyChannelProfile 
OUTPUT_CHANNEL=$FABRIC_ORDERER_HOME/my-channel.tx 
CHANNELID=mychannelid

echo    '================ Writing $CHANNELID ================'
configtxgen -profile $PROFILE -outputCreateChannelTx $OUTPUT_CHANNEL -channelID $CHANNELID
echo "you can use configtxgen -inspectBlock <$OUTPUT_CHANNEL> to verifiy the generated block "
echo    '======= Done. Launch by executing orderer ======'
