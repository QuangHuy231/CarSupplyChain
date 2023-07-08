export PATH=/home/huy/CarSupplyChain/FabricNetwork/bin:$PATH
echo "Enrolling the CA admin"
mkdir -p ./bootstrapAdmin  
cp /home/huy/CarSupplyChain/FabricNetwork/Dealer/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Dealer/bootstrapAdmin/tls-cert.pem

export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Dealer/bootstrapAdmin
set -x
fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-dealer --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/bootstrapAdmin/tls-cert.pem
  { set +x; } 2>/dev/null
set -x
fabric-ca-client register --caname ca-dealer --id.name dealer-admin --id.secret dealer-adminpw --id.type admin --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/bootstrapAdmin/tls-cert.pem
  { set +x; } 2>/dev/null
mkdir -p ./Admin
cp /home/huy/CarSupplyChain/FabricNetwork/Dealer/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin
set -x
fabric-ca-client enroll -u https://dealer-admin:dealer-adminpw@localhost:9054 --caname ca-dealer -M /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/msp --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls-cert.pem
  { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/msp/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/msp/keystore/server.key
set -x
fabric-ca-client enroll -u https://dealer-admin:dealer-adminpw@localhost:9054 --caname ca-dealer -M /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls --enrollment.profile tls --csr.hosts localhost --csr.hosts peer0.dealer.example.com --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls-cert.pem
  { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/tls/keystore/server.key
set -x
echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-dealer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-dealer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-dealer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-dealer.pem
    OrganizationalUnitIdentifier: orderer' > /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/msp/config.yaml

  { set +x; } 2>/dev/null  

export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Dealer/bootstrapAdmin
set -x
fabric-ca-client register --caname ca-dealer --id.name peer --id.secret peerpw --id.type peer --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/bootstrapAdmin/tls-cert.pem
{ set +x; } 2>/dev/null
set -x
mkdir -p ./Peer
cp /home/huy/CarSupplyChain/FabricNetwork/Dealer/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Dealer/Peer/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Dealer/Peer
{ set +x; } 2>/dev/null
set -x
fabric-ca-client enroll -u https://peer:peerpw@localhost:9054 --caname ca-dealer -M /home/huy/CarSupplyChain/FabricNetwork/Dealer/Peer/msp --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/Peer/tls-cert.pem
{ set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Dealer/Peer/msp/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Dealer/Peer/msp/keystore/server.key
set -x
fabric-ca-client enroll -u https://peer:peerpw@localhost:9054 --caname ca-dealer -M /home/huy/CarSupplyChain/FabricNetwork/Dealer/Peer/tls --enrollment.profile tls --csr.hosts localhost --csr.hosts peer0.dealer.example.com --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Dealer/Peer/tls-cert.pem
{ set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Dealer/Peer/tls/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Dealer/Peer/tls/keystore/server.key

set -x
cp /home/huy/CarSupplyChain/FabricNetwork/Dealer/Admin/msp/config.yaml /home/huy/CarSupplyChain/FabricNetwork/Dealer/Peer/msp/config.yaml
{ set +x; } 2>/dev/null