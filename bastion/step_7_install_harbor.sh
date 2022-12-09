#!/bin/bash
#copy harbor binary to bastion server on /data/software/harbor
# wget
tar zxvf harbor-offline-installer-v2.5.3.tgz
cd harbor
mkdir certs
#generate ca certification

openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Hangzhou/L=Hangzhou/O=ewell/OU=Personal/CN=registry.ocp4.ewell.cc" \
 -key ca.key \
 -out ca.crt

openssl genrsa -out registry.openshift4.example.com.key 4096

openssl req -sha512 -new \
    -subj "/C=CN/ST=Shanghai/L=Shanghai/O=example/OU=Personal/CN=registry.openshift4.example.com" \
    -key registry.openshift4.example.com.key \
    -out registry.openshift4.example.com.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1= registry.openshift4.example.com
DNS.2= registry.openshift4.example.com
DNS.3= registry.openshift4.example.com
EOF

openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in registry.openshift4.example.com.csr \
    -out registry.openshift4.example.com.crt



openssl x509 -inform PEM -in registry.openshift4.example.com.crt -out registry.openshift4.example.com.cert

cd certs
mkdir -p /data/certs
cp registry.openshift4.example.com.crt /data/certs
cp registry.openshift4.example.com.key  /data/certs

#copy certs to docker,default port 80,other port please create folder
# like as  folder:port
mkdir -p /etc/docker/certs.d/registry.openshift4.example.com
cp ca.crt registry.openshift4.example.com.key registry.openshift4.example.com.cert
   /etc/docker/certs.d/registry.openshift4.example.com

cp harbor.yml.tmpl  harbor.yml
vi harbor.yml
#hostname: registry.openshift4.example.com   #主机名称或者IP地址
#https:   #不使用https安全加密端口
#  port: 443
#  certificate: /your/certificate/path
#  private_key: /your/private/key/path
#certificate: /data/certs/registry.openshift4.example.com.crt
#private_key: /data/certs/registry.openshift4.example.com.key
#external_url: https://registry.openshift4.example.com

#Default user: admin
#Default password: #如果没有修改默认：Harbor12345

./prepare



#generate certs

mkdir -p /opt/harbor/cert
cd /opt/harbor/cert

openssl genrsa -out ca.key 4096

openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=registry.ocp4.example.com" \
 -key ca.key \
 -out ca.crt

openssl genrsa -out registry.ocp4.example.com.key 4096

openssl req -sha512 -new \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=registry.ocp4.example.com" \
    -key registry.ocp4.example.com.key \
    -out registry.ocp4.example.com.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=registry.ocp4.example.com
DNS.2=registry.ocp4.example.com
DNS.3=registry.ocp4.example.com
EOF

openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in registry.ocp4.example.com.csr \
    -out registry.ocp4.example.com.crt

mkdir -p /data/cert/
cp registry.ocp4.example.com.crt /data/cert/
cp registry.ocp4.example.com.key /data/cert/

openssl x509 -inform PEM -in registry.ocp4.example.com.crt -out registry.ocp4.example.com.cert
#mkdir -p /etc/docker/certs.d/registry.ocp4.universalchain.com.cn:8443
mkdir -p /etc/docker/certs.d/registry.ocp4.example.com:8443
cp registry.ocp4.example.com.cert /etc/docker/certs.d/registry.ocp4.example.com:8443/
cp registry.ocp4.example.com.key /etc/docker/certs.d/registry.ocp4.example.com:8443/
cp ca.crt /etc/docker/certs.d/registry.ocp4.example.com:8443/
./install.sh --with-notary --with-clair --with-chartmuseum

#harbor
cat >/etc/systemd/system/harbor.service<<EOF
[Unit]
Description=Harbor
After=docker.service systemd-networkd.service systemd-resolved.service
Requires=docker.service
Documentation=http://github.com/goharbor/harbor

[Service]
Type=simple
Restart=on-failure
RestartSec=5
ExecStart=/usr/local/bin/docker-compose -f /opt/harbor/docker-compose.yml up
ExecStop=/usr/local/bin/docker-compose -f /opt/harbor/docker-compose.yml down

[Install]
WantedBy=multi-user.target
EOF

systemctl enable harbor

cat > /etc/docker/daemon.json <<-EOF
{
  "insecure-registries" : ["registry.ocp4.example.com:8443"]
}
EOF

cp ./cert/registry.ocp4.example.com.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust extract
