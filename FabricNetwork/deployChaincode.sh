export CORE_PEER_TLS_ENABLED=true
export CHANNEL_NAME=mychannel
export CHAINCODE_NAME=mycc
export PATH=${PWD}/bin:$PATH
export FABRIC_CFG_PATH=/home/huy/CarSupplyChain/FabricNetwork/config
export ORDERER_TLS_ROOT_CA=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/tls/tlscacerts/tls-localhost-8054-ca-manufactorer.pem
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


installChaincode(){
setPeer0Supplier
peer lifecycle chaincode install /home/huy/CarSupplyChain/FabricNetwork/chaincode-typescript/mycc.tgz
setPeer0Manufactorer
peer lifecycle chaincode install /home/huy/CarSupplyChain/FabricNetwork/chaincode-typescript/mycc.tgz
setPeer0Dealer
peer lifecycle chaincode install /home/huy/CarSupplyChain/FabricNetwork/chaincode-typescript/mycc.tgz
}





queryInstall(){
    setPeer0Supplier
peer lifecycle chaincode queryinstalled
}



approveformyorg(){
    setPeer0Supplier
    peer lifecycle chaincode approveformyorg -o localhost:7050 --tls --cafile $ORDERER_TLS_ROOT_CA --channelID $CHANNEL_NAME   --name $CHAINCODE_NAME --version 1.0 --package-id $CC_PACKAGE_ID  --sequence 1
    setPeer0Manufactorer
    peer lifecycle chaincode approveformyorg -o localhost:7050 --tls --cafile $ORDERER_TLS_ROOT_CA --channelID $CHANNEL_NAME   --name $CHAINCODE_NAME --version 1.0 --package-id $CC_PACKAGE_ID  --sequence 1
    setPeer0Dealer
    peer lifecycle chaincode approveformyorg -o localhost:7050 --tls --cafile $ORDERER_TLS_ROOT_CA --channelID $CHANNEL_NAME   --name $CHAINCODE_NAME --version 1.0 --package-id $CC_PACKAGE_ID  --sequence 1
}

checkApprove(){
    setPeer0Supplier
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME  --version 1.0 --sequence 1 --tls --cafile $ORDERER_TLS_ROOT_CA --output json
}

commitChaincode(){
    setPeer0Supplier

    peer lifecycle chaincode commit -o localhost:7050 --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version 1.0 --sequence 1 --tls --cafile $ORDERER_TLS_ROOT_CA --peerAddresses localhost:7051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls/tlscacerts/tls-localhost-7054-ca-supplier.pem --peerAddresses localhost:8051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls/tlscacerts/tls-localhost-8054-ca-manufactorer.pem --peerAddresses localhost:9051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls/tlscacerts/tls-localhost-9054-ca-dealer.pem  
}

initLedger(){
    setPeer0Supplier

    # peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_TLS_ROOT_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME --peerAddresses localhost:7051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls/tlscacerts/tls-localhost-7054-ca-supplier.pem --peerAddresses localhost:8051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls/tlscacerts/tls-localhost-8054-ca-manufactorer.pem --peerAddresses localhost:9051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls/tlscacerts/tls-localhost-9054-ca-dealer.pem  -c '{"function":"InitLedger","Args":[]}'

    peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_TLS_ROOT_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME --peerAddresses localhost:7051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls/tlscacerts/tls-localhost-7054-ca-supplier.pem --peerAddresses localhost:8051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls/tlscacerts/tls-localhost-8054-ca-manufactorer.pem --peerAddresses localhost:9051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls/tlscacerts/tls-localhost-9054-ca-dealer.pem  -c '{"Args":["CreateAsset","asset100","red","100", "Huy", "100"]}'

}


# installChaincode
# queryInstall
export CC_PACKAGE_ID=mycc_1.0:bee219ab5abd4185897ffb1c08812d5e2547eece826db3bc20e2cf5954b0c178


# docker build -t hyperledger/mycc --build-arg CC_SERVER_PORT=9999 .
# docker run -it -d --name mycc  --network fabric_test --hostname=mycc -e CHAINCODE_SERVER_ADDRESS=0.0.0.0:9999 -e CHAINCODE_ID=mycc_1.0:bee219ab5abd4185897ffb1c08812d5e2547eece826db3bc20e2cf5954b0c178  hyperledger/mycc

# approveformyorg
# checkApprove
# commitChaincode
# initLedger

setPeer0Supplier
peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["GetAllAssets"]}'

