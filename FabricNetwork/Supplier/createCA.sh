export PATH=/home/huy/CarSupplyChain/FabricNetwork/bin:$PATH
echo "Enrolling the CA admin"
mkdir -p ./bootstrapAdmin  
cp /home/huy/CarSupplyChain/FabricNetwork/Supplier/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Supplier/bootstrapAdmin/tls-cert.pem

export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Supplier/bootstrapAdmin
set -x
fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-supplier --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/bootstrapAdmin/tls-cert.pem
  { set +x; } 2>/dev/null
set -x
fabric-ca-client register --caname ca-supplier --id.name supplier-admin --id.secret supplier-adminpw --id.type admin --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/bootstrapAdmin/tls-cert.pem
  { set +x; } 2>/dev/null
mkdir -p ./Admin
cp /home/huy/CarSupplyChain/FabricNetwork/Supplier/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin
set -x
fabric-ca-client enroll -u https://supplier-admin:supplier-adminpw@localhost:7054 --caname ca-supplier -M /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/msp --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls-cert.pem
  { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/msp/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/msp/keystore/server.key
set -x
fabric-ca-client enroll -u https://supplier-admin:supplier-adminpw@localhost:7054 --caname ca-supplier -M /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls --enrollment.profile tls --csr.hosts localhost --csr.hosts peer0.supplier.example.com --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls-cert.pem
  { set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/tls/keystore/server.key
set -x
echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-supplier.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-supplier.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-supplier.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-supplier.pem
    OrganizationalUnitIdentifier: orderer' > /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/msp/config.yaml

  { set +x; } 2>/dev/null  

export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Supplier/bootstrapAdmin
set -x
fabric-ca-client register --caname ca-supplier --id.name peer --id.secret peerpw --id.type peer --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/bootstrapAdmin/tls-cert.pem
{ set +x; } 2>/dev/null
set -x
mkdir -p ./Peer
cp /home/huy/CarSupplyChain/FabricNetwork/Supplier/CA-server/tls-cert.pem /home/huy/CarSupplyChain/FabricNetwork/Supplier/Peer/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=/home/huy/CarSupplyChain/FabricNetwork/Supplier/Peer
{ set +x; } 2>/dev/null
set -x
fabric-ca-client enroll -u https://peer:peerpw@localhost:7054 --caname ca-supplier -M /home/huy/CarSupplyChain/FabricNetwork/Supplier/Peer/msp --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/Peer/tls-cert.pem
{ set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Supplier/Peer/msp/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Supplier/Peer/msp/keystore/server.key
set -x
fabric-ca-client enroll -u https://peer:peerpw@localhost:7054 --caname ca-supplier -M /home/huy/CarSupplyChain/FabricNetwork/Supplier/Peer/tls --enrollment.profile tls --csr.hosts localhost --csr.hosts peer0.supplier.example.com --tls.certfiles /home/huy/CarSupplyChain/FabricNetwork/Supplier/Peer/tls-cert.pem
{ set +x; } 2>/dev/null
mv /home/huy/CarSupplyChain/FabricNetwork/Supplier/Peer/tls/keystore/* /home/huy/CarSupplyChain/FabricNetwork/Supplier/Peer/tls/keystore/server.key

set -x
cp /home/huy/CarSupplyChain/FabricNetwork/Supplier/Admin/msp/config.yaml /home/huy/CarSupplyChain/FabricNetwork/Supplier/Peer/msp/config.yaml
{ set +x; } 2>/dev/null