export CORE_PEER_TLS_ENABLED=true
export CHANNEL_NAME=mychannel
export CHAINCODE_NAME=chaincode-carsupply
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
peer lifecycle chaincode install /home/huy/CarSupplyChain/FabricNetwork/chaincode-carsupply/chaincode-carsupply.tgz
setPeer0Manufactorer
peer lifecycle chaincode install /home/huy/CarSupplyChain/FabricNetwork/chaincode-carsupply/chaincode-carsupply.tgz
setPeer0Dealer
peer lifecycle chaincode install /home/huy/CarSupplyChain/FabricNetwork/chaincode-carsupply/chaincode-carsupply.tgz
}





queryInstall(){
    setPeer0Supplier
peer lifecycle chaincode queryinstalled
}



approveformyorg(){
    setPeer0Supplier
    peer lifecycle chaincode approveformyorg -o localhost:7050 --tls --cafile $ORDERER_TLS_ROOT_CA --channelID $CHANNEL_NAME   --name $CHAINCODE_NAME --signature-policy "OR('SupplierMSP.member', 'ManufactorerMSP.member', 'DealerMSP.member')" --version 1.0 --package-id $CC_PACKAGE_ID  --sequence 1
    setPeer0Manufactorer
    peer lifecycle chaincode approveformyorg -o localhost:7050 --tls --cafile $ORDERER_TLS_ROOT_CA --channelID $CHANNEL_NAME   --name $CHAINCODE_NAME --signature-policy "OR('SupplierMSP.member', 'ManufactorerMSP.member', 'DealerMSP.member')" --version 1.0 --package-id $CC_PACKAGE_ID  --sequence 1
    setPeer0Dealer
    peer lifecycle chaincode approveformyorg -o localhost:7050 --tls --cafile $ORDERER_TLS_ROOT_CA --channelID $CHANNEL_NAME   --name $CHAINCODE_NAME --signature-policy "OR('SupplierMSP.member', 'ManufactorerMSP.member', 'DealerMSP.member')" --version 1.0 --package-id $CC_PACKAGE_ID  --sequence 1
}

checkApprove(){
    setPeer0Supplier
peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME  --signature-policy "OR('SupplierMSP.member', 'ManufactorerMSP.member', 'DealerMSP.member')" --version 1.0 --sequence 1 --tls --cafile $ORDERER_TLS_ROOT_CA --output json
}

commitChaincode(){
    setPeer0Supplier

    peer lifecycle chaincode commit -o localhost:7050 --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --signature-policy "OR('SupplierMSP.member', 'ManufactorerMSP.member', 'DealerMSP.member')" --version 1.0 --sequence 1 --tls --cafile $ORDERER_TLS_ROOT_CA --peerAddresses localhost:7051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls/tlscacerts/tls-localhost-7054-ca-supplier.pem --peerAddresses localhost:8051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls/tlscacerts/tls-localhost-8054-ca-manufactorer.pem --peerAddresses localhost:9051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls/tlscacerts/tls-localhost-9054-ca-dealer.pem  
}

initLedger(){
    setPeer0Manufactorer

    # peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_TLS_ROOT_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME --peerAddresses localhost:7051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls/tlscacerts/tls-localhost-7054-ca-supplier.pem --peerAddresses localhost:8051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls/tlscacerts/tls-localhost-8054-ca-manufactorer.pem --peerAddresses localhost:9051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls/tlscacerts/tls-localhost-9054-ca-dealer.pem  -c '{"function":"InitLedger","Args":[]}'

    peer chaincode invoke -o localhost:7050 --tls --cafile $ORDERER_TLS_ROOT_CA -C $CHANNEL_NAME -n $CHAINCODE_NAME --peerAddresses localhost:7051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls/tlscacerts/tls-localhost-7054-ca-supplier.pem  --peerAddresses localhost:8051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls/tlscacerts/tls-localhost-8054-ca-manufactorer.pem --peerAddresses localhost:9051 --tlsRootCertFiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls/tlscacerts/tls-localhost-9054-ca-dealer.pem   -c '{"Args":["CreateCar", "car1", "huy", "whell1", "engine1", "transmission1", "chassis1"]}'

}


# installChaincode
# queryInstall
export CC_PACKAGE_ID=chaincode-carsupply_1.0:dc8734e16e2d29aa9e82fae60bde0e3297fa937c4406f98695fad013ad20420b


# docker build -t hyperledger/chaincode-carsupply --build-arg CC_SERVER_PORT=9999 .
# docker run -it -d --name chaincode-carsupply  --network fabric_test --hostname=chaincode-carsupply -e CHAINCODE_SERVER_ADDRESS=0.0.0.0:9999 -e CHAINCODE_ID=chaincode-carsupply_1.0:dc8734e16e2d29aa9e82fae60bde0e3297fa937c4406f98695fad013ad20420b  hyperledger/chaincode-carsupply

# approveformyorg
# checkApprove
# commitChaincode
# initLedger

setPeer0Supplier
peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["GetAllCars"]}'


