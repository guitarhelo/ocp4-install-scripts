#!/bin/bash
#OCP容器镜像服务
tar -xzvf ocp-registry.tar.gz -C /
cd /opt/ibm/registry/certs/
#update certs
openssl req -newkey rsa:2048 -nodes -keyout server.key -subj "/C=CN/ST=GD/L=SZ/O=IBM, Inc./CN=*.ocp4uat.trinasolar.com" -out server.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:ocp4uat.trinasolar.com,DNS:api.ocp4uat.trinasolar.com") -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
#update password
cd /opt/ibm/registry/auth
htpasswd -bBc htpasswd admin Abcd@1234

#创建docker-registry容器(一条命令)
podman run -d --name ocp-registry \
-p 5000:5000 --restart=always \
-v /opt/ibm/registry/data:/var/lib/registry:z \
-v /opt/ibm/registry/auth:/auth:z \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
-e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
-v /opt/ibm/registry/certs:/certs:z \
-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/server.crt \
-e REGISTRY_HTTP_TLS_KEY=/certs/server.key \
docker.io/library/registry:2

#测试docker registry(三条命令)
cp /opt/ibm/registry/certs/ca.crt /etc/pki/ca-trust/source/anchors
update-ca-trust extract
curl -u openshift:redhat https://api.ocp4uat.trinasolar.com:5000/v2/_catalog
#配置docker registry开机自启动(三条命令)
podman generate systemd --new ocp-registry > /etc/systemd/system/ocp-registry.service
systemctl enable ocp-registry.service --now
podman ps

curl -u admin:Abcd@1234 -k https://api.ocp4uat.trinasolar.com:5000/v2/_catalog
-k #是忽略证书校验
curl -u admin:Abcd@1234  https://api.ocp4uat.trinasolar.com:5000/v2/_catalog
#检查证书是否授信



