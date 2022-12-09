#for harbor
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
DNS.2=registry.ocp4.ewell.cc
DNS.3= registry.ocp4.ewell.cc
EOF


openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in registry.ocp4.ewell.cc.csr \
    -out registry.ocp4.ewell.cc.crt

openssl x509 -inform PEM -in registry.ocp4.ewell.cc.crt -out registry.ocp4.ewell.cc.cert