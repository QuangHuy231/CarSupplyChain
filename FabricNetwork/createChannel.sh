export PATH=${PWD}/bin:$PATH
export CHANNEL_NAME=mychannel
export CORE_PEER_TLS_ENABLED=true
export FABRIC_CFG_PATH=/home/huy/CarSupplyChain/FabricNetwork/config
createChannelGenesisBlock(){
    configtxgen -configPath /home/huy/CarSupplyChain/FabricNetwork/config/ -profile ThreeOrgsApplicationGenesis -outputBlock ./${CHANNEL_NAME}.block -channelID $CHANNEL_NAME
}

setOsnAdmin(){
export ORDERER_TLS_ROOT_CA=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/tls/tlscacerts/tls-localhost-8054-ca-manufactorer.pem

export ORDERER1_TLS_SIGN_CERT=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/tls/signcerts/cert.pem
export ORDERER1_TLS_PRIVATE_KEY=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/tls/keystore/server.key

export ORDERER2_TLS_SIGN_CERT=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/tls/signcerts/cert.pem
export ORDERER2_TLS_PRIVATE_KEY=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/tls/keystore/server.key

export ORDERER3_TLS_SIGN_CERT=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/tls/signcerts/cert.pem
export ORDERER3_TLS_PRIVATE_KEY=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/tls/keystore/server.key
}


setPeer0Supplier(){

export CORE_PEER_LOCALMSPID="SupplierMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls/tlscacerts/tls-localhost-7054-ca-supplier.pem
export CORE_PEER_MSPCONFIGPATH=/home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/msp
export CORE_PEER_ADDRESS=localhost:7051

}
setPeer0Manufactorer(){

export CORE_PEER_LOCALMSPID="ManufactorerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls/tlscacerts/tls-localhost-8054-ca-manufactorer.pem
export CORE_PEER_MSPCONFIGPATH=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/msp
export CORE_PEER_ADDRESS=localhost:8051

}

setPeer0Dealer(){

export CORE_PEER_LOCALMSPID="DealerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls/tlscacerts/tls-localhost-9054-ca-dealer.pem
export CORE_PEER_MSPCONFIGPATH=/home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/msp
export CORE_PEER_ADDRESS=localhost:9051

}



createChannel(){
    setOsnAdmin
    osnadmin channel join --channelID $CHANNEL_NAME --config-block ./${CHANNEL_NAME}.block -o localhost:7053 --ca-file $ORDERER_TLS_ROOT_CA --client-cert $ORDERER1_TLS_SIGN_CERT --client-key $ORDERER1_TLS_PRIVATE_KEY
}


addOrderer(){
    setOsnAdmin
    osnadmin channel join --channelID $CHANNEL_NAME --config-block ./${CHANNEL_NAME}.block -o localhost:8053 --ca-file $ORDERER_TLS_ROOT_CA --client-cert $ORDERER2_TLS_SIGN_CERT --client-key $ORDERER2_TLS_PRIVATE_KEY
    osnadmin channel join --channelID $CHANNEL_NAME --config-block ./${CHANNEL_NAME}.block -o localhost:9053 --ca-file $ORDERER_TLS_ROOT_CA --client-cert $ORDERER3_TLS_SIGN_CERT --client-key $ORDERER3_TLS_PRIVATE_KEY
}


joinPeer(){
    setPeer0Supplier
    peer channel join -b ./$CHANNEL_NAME.block
    setPeer0Manufactorer
    peer channel join -b ./$CHANNEL_NAME.block
    setPeer0Dealer
    peer channel join -b ./$CHANNEL_NAME.block
}




echo "Generating channel genesis block '${CHANNEL_NAME}.block'"
createChannelGenesisBlock

createChannel
addOrderer
joinPeer

