# this is important for all orderer related scripts (the base FABRIC_CFG_PATH=$HYPERLEDGER_HOME/fabric)
export FABRIC_CFG_PATH=$FABRIC_CFG_PATH/orderer
echo "FABRIC_CFG_PATH: $FABRIC_CFG_PATH"

export ORDERER_FILELEDGER_LOCATION="$FABRIC_CFG_PATH/ledgers/ledger" 

sudo mkdir /var/ledgers						
sudo chown ubuntu:ubuntu /var/ledgers/
cd $FABRIC_CFG_PATH	

ORDERER_LOG=$FABRIC_CFG_PATH/orderer.log

#sudo -E orderer 2> $ORDERER_LOG &
orderer 2> $ORDERER_LOG &

echo "===> Done. Please check logs under $ORDERER_LOG"