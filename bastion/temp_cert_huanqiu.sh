#for harbor
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Suzhou/L=Suzhou/O=universalchain/OU=Personal/CN=registry.ocp4.universalchain.cc" \
 -key ca.key \
 -out ca.crt


 openssl genrsa -out registry.ocp4.universalchain.com.cn.key 4096

 openssl req -sha512 -new \
     -subj "/C=CN/ST=Suzhou/L=Suzhou/O=universalchain/OU=Personal/CN=registry.ocp4.universalchain.com.cn" \
     -key registry.ocp4.universalchain.com.cn.key \
     -out registry.ocp4.universalchain.com.cn.csr


cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1= registry.ocp4.universalchain.com.cn
DNS.2=registry.ocp4.universalchain.com.cn
DNS.3= registry.ocp4.universalchain.com.cn
EOF


openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in registry.ocp4.universalchain.com.cn.csr \
    -out registry.ocp4.universalchain.com.cn.crt

openssl x509 -inform PEM -in registry.ocp4.universalchain.com.cn.crt -out registry.ocp4.universalchain.com.cn.cert