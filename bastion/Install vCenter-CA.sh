#Install vCenter
curl -k -L -O  https://vcenter/certs/download.zip
unzip download.zip
cp -v certs/lin/*  /etc/pki/ca-trust/source/anchors/
update-ca-trust
