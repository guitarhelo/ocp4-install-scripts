#!/bin/bash
mkdir -p /etc/nginx/templates
mkdir -p /usr/share/nginx/html/{ign,iso}
cat >/etc/nginx/templates/default.conf.template<<EOF
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        autoindex on;
        autoindex_exact_size off;
        autoindex_format html;
        autoindex_localtime on;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
EOF
chmod -R a+rwx /etc/nginx/
chmod -R a+rwx /usr/share/nginx/

podman run -d --name nginx-ocp4 \
  --restart always \
  -p 8088:80 \
  -v /etc/nginx/templates:/etc/nginx/templates \
  -v /usr/share/nginx/html:/usr/share/nginx/html:ro \
  nginx:1.21.6-alpine

podman generate systemd --new --name nginx > /etc/systemd/system/nginx.service
systemctl enable nginx.service --now
