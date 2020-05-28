#!/bin/bash
#------------------------Generates CERT----------------------------------

#------------------------CA File Names------------------------------------
CA_Key=CA.key
CA_Pem=CA.pem
#------------------------File Names------------------------------------
KEY=KEY.key
CSR=CSR.csr
CRT=CRT.crt
EXT=extFile.ext
PFX=PFX.pfx

#-------------------------CERT Info--------------------------------------
COUNTRY="US"          
STATE="California"      
LOCALITY="Los Angeles"           
ORGNAME="Company, Inc."      
ORGUNIT="Software Devlopment" 
COMMONNAME="Company"    
EMAIL="Company@domain.com"
#CHALLANGE=""                # challenge password
COMPANY="Company"                  
#----------------------------------------------------------------------
#------------------------Days------------------------------------------
DAYS="7305"

umask 277
#----------------------OpenSSL Commands--------------------------------

#1 Gen Key
openssl genrsa -out $KEY 2048

#2 Gen Csr
cat <<__EOF__ | openssl req -new -key $KEY -out $CSR -passin file:ChallangePass.txt
${COUNTRY}
${STATE}
${LOCALITY}
${ORGNAME}
${ORGUNIT}
${COMMONNAME}
${EMAIL}
${COMPANY}
__EOF__

#3 Gen Cert
openssl x509 -req -in $CSR -CA $CA_Pem -CAkey $CA_Key -CAcreateserial -out $CRT -days 7305 -sha256 -extfile $EXT -passin file:CAPass.txt


#3 Gen PFX
openssl pkcs12 -export -inkey $KEY -in $CRT -out $PFX -passin file:CAPass.txt -passout file:CertExportPass.txt

#clear

