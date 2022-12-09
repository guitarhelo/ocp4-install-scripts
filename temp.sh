

openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Hangzhou/L=Hangzhou/O=ewell/OU=Personal/CN=registry.ocp4.ewell.cc" \
 -key ca.key \
 -out ca.crt
openssl genrsa -out registry.ocp4.ewell.cc.key 4096

openssl req -sha512 -new \
    -subj "/C=CN/ST=Hangzhou/L=Hangzhou/O=ewell/OU=Personal/CN=registry.ocp4.ewell.cc" \
    -key registry.ocp4.ewell.cc.key \
    -out registry.ocp4.ewell.cc.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1= registry.ocp4.ewell.cc
DNS.2= api.ocp4.ewell.cc
DNS.3= ocp4.ewell.cc
EOF

openssl x509 -req -extfile v3.ext -days 3650 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt

openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in registry.ocp4.ewell.cc.csr \
    -out registry.ocp4.ewell.cc.crt



openssl x509 -inform PEM -in registry.ocp4.ewell.cc.crt -out registry.ocp4.ewell.cc.cert


mkdir -p /data/certs
cp registry.ocp4.ewell.cc.crt /data/certs
cp registry.ocp4.ewell.cc.key  /data/certs

#copy certs to docker,default port 80,other port please create folder
# like as  folder:port
mkdir -p /etc/docker/certs.d/registry.ocp4.ewell.cc
cp ca.crt registry.ocp4.ewell.cc.key registry.ocp4.ewell.cc.cert
   /etc/docker/certs.d/registry.ocp4.ewell.cc


openssl x509 -req -extfile <(printf "subjectAltName=DNS:ocp4.ewell.cc,DNS:api.ocp4.ewell.cc”) -days 3650 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
