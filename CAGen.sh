#!/bin/bash
#------------------------Generates CA----------------------------------

#------------------------file Names------------------------------------
CA_Key=CA.key
CA_Pem=CA.pem
CA_Pfx=CA.pfx

#-------------------------CA Info--------------------------------------
COUNTRY="US"          
STATE="California"      
LOCALITY="Los Angeles"           
ORGNAME="Root Authority"      
ORGUNIT="CA" 
COMMONNAME="CA"    
EMAIL="ca@domain.com"
#----------------------------------------------------------------------
#------------------------Days------------------------------------------
DAYS="7305"

umask 277
#----------------------OpenSSL Commands--------------------------------

#1 Gen RSA CA Key
openssl genrsa -des3 -out $CA_Key -passout file:CAPass.txt 2048

#2 Gen CA Pem
cat <<__EOF__ | openssl req -x509 -passin file:CAPass.txt -new -nodes -key $CA_Key -sha256 -days $DAYS -out $CA_Pem
${COUNTRY}
${STATE}
${LOCALITY}
${ORGNAME}
${ORGUNIT}
${COMMONNAME}
${EMAIL}
__EOF__

#3 Gen CA PFX
openssl pkcs12 -export -inkey $CA_Key -in $CA_Pem -out $CA_Pfx -passin file:CAPass.txt -passout file:CAExportPass.txt

#clear

