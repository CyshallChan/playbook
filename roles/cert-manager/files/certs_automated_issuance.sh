#!/bin/bash


#!/bin/bash
set -x
export domain=$1
export CF_Email=$2
export CF_Key=$3

rm -fv ${domain}.key ${domain}.pem -f
rm -fv /etc/ssl/${domain}.* -f

# Try to issue a certificate from ZeroSSL. If it fails, try Let's Encrypt.
  
curl https://get.acme.sh | sh -s email=cyshallchan@outlook.com
sh ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt --issue --force --dns dns_cf -d ${domain} -d "*.${domain}"
if [ $? -eq 0 ]; then
    echo "Certificate from letsencrypt successfully issued"
else
  sh ~/.acme.sh/acme.sh --set-default-ca --server zerossl --issue --force --dns dns_cf -d ${domain} -d "*.${domain}"
  if [ $? -eq 0 ]; then
      echo "Certificate from zerossl successfully issued"
  else
      echo "Command failed"
      exit 1
  fi   
fi

cat ~/.acme.sh/${domain}_ecc/${domain}.cer > ${domain}.pem
cat ~/.acme.sh/${domain}_ecc/ca.cer >> ${domain}.pem
cat ~/.acme.sh/${domain}_ecc/${domain}.key > ${domain}.key
sudo cp ${domain}.pem /etc/ssl/ -f && sudo cp ${domain}.key /etc/ssl/ -f
