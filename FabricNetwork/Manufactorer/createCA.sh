export PATH=/home/huy/CarSupplyChain/FabricNetwork/bin:$PATH
echo "Enrolling the CA admin"
mkdir -p ./bootstrapAdmin  
cp /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/bootstrapAdmin/tls-cert.pem

export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/bootstrapAdmin
set -x
fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-manufactorer --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/bootstrapAdmin/tls-cert.pem
  { set +x; } 2>/dev/null
set -x
fabric-ca-client register --caname ca-manufactorer --id.name manufactorer-admin --id.secret manufactorer-adminpw --id.type admin --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/bootstrapAdmin/tls-cert.pem
  { set +x; } 2>/dev/null
mkdir -p ./Admin
cp /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin
set -x
fabric-ca-client enroll -u https://manufactorer-admin:manufactorer-adminpw@localhost:8054 --caname ca-manufactorer -M /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/msp --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls-cert.pem
  { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/msp/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/msp/keystore/server.key
set -x
fabric-ca-client enroll -u https://manufactorer-admin:manufactorer-adminpw@localhost:8054 --caname ca-manufactorer -M /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls --enrollment.profile tls --csr.hosts localhost --csr.hosts peer0.manufactorer.example.com --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls-cert.pem
  { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/tls/keystore/server.key
set -x
echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-manufactorer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-manufactorer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-manufactorer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-manufactorer.pem
    OrganizationalUnitIdentifier: orderer' > /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/msp/config.yaml

  { set +x; } 2>/dev/null  

export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/bootstrapAdmin
set -x
fabric-ca-client register --caname ca-manufactorer --id.name peer --id.secret peerpw --id.type peer --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/bootstrapAdmin/tls-cert.pem
{ set +x; } 2>/dev/null
set -x
mkdir -p ./Peer
cp /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Peer/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Peer
{ set +x; } 2>/dev/null
set -x
fabric-ca-client enroll -u https://peer:peerpw@localhost:8054 --caname ca-manufactorer -M /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Peer/msp --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Peer/tls-cert.pem
{ set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Peer/msp/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Peer/msp/keystore/server.key
set -x
fabric-ca-client enroll -u https://peer:peerpw@localhost:8054 --caname ca-manufactorer -M /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Peer/tls --enrollment.profile tls --csr.hosts localhost --csr.hosts peer0.manufactorer.example.com --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Peer/tls-cert.pem
{ set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Peer/tls/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Peer/tls/keystore/server.key

set -x
cp /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/msp/config.yaml /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Peer/msp/config.yaml
{ set +x; } 2>/dev/null



export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/bootstrapAdmin
  set -x
fabric-ca-client register --caname ca-manufactorer --id.name orderer1 --id.secret orderer1pw --id.type orderer --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/bootstrapAdmin/tls-cert.pem
  { set +x; } 2>/dev/null

 set -x
fabric-ca-client register --caname ca-manufactorer --id.name orderer2 --id.secret orderer2pw --id.type orderer --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/bootstrapAdmin/tls-cert.pem
  { set +x; } 2>/dev/null

  set -x
fabric-ca-client register --caname ca-manufactorer --id.name orderer3 --id.secret orderer3pw --id.type orderer --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/bootstrapAdmin/tls-cert.pem
  { set +x; } 2>/dev/null


mkdir -p ./Orderer1
cp /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1
  set -x
fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:8054 --caname ca-manufactorer -M /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/msp --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/tls-cert.pem
 { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/msp/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/msp/keystore/server.key
    set -x
fabric-ca-client enroll -u https://orderer1:orderer1pw@localhost:8054 --caname ca-manufactorer -M /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/tls --enrollment.profile tls  --csr.hosts localhost --csr.hosts orderer1.example.com --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/tls-cert.pem
  { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/tls/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/tls/keystore/server.key
set -x
cp /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/msp/config.yaml /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer1/msp/config.yaml
{ set +x; } 2>/dev/null


mkdir -p ./Orderer2
cp /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2
  set -x
fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:8054 --caname ca-manufactorer -M /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/msp --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/tls-cert.pem
 { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/msp/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/msp/keystore/server.key
    set -x
fabric-ca-client enroll -u https://orderer2:orderer2pw@localhost:8054 --caname ca-manufactorer -M /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/tls --enrollment.profile tls  --csr.hosts localhost --csr.hosts orderer2.example.com --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/tls-cert.pem
  { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/tls/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/tls/keystore/server.key
set -x
cp /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/msp/config.yaml /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer2/msp/config.yaml
{ set +x; } 2>/dev/null


mkdir -p ./Orderer3
cp /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3
  set -x
fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:8054 --caname ca-manufactorer -M /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/msp --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/tls-cert.pem
 { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/msp/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/msp/keystore/server.key
    set -x
fabric-ca-client enroll -u https://orderer3:orderer3pw@localhost:8054 --caname ca-manufactorer -M /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/tls --enrollment.profile tls  --csr.hosts localhost --csr.hosts orderer3.example.com --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/tls-cert.pem
  { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/tls/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/tls/keystore/server.key

set -x
cp /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Admin/msp/config.yaml /home/huy/CarSupplyChain/FabricNetwork/Manufactorer/Orderer3/msp/config.yaml
{ set +x; } 2>/dev/null
