#!/bin/bash
mkdir -p /etc/bind
mkdir -p /var/lib/bind
mkdir -p /var/cache/bind
 dnf install bind bind-utils

 # systemctl start named
 # systemctl enable named
#创建bind主配置文件
cat >/etc/bind/named.conf<<EOF
options {
        directory "/var/cache/bind";
        listen-on { any; };
        listen-on-v6 { any; };
        allow-query { any; };
        allow-query-cache { any; };
        recursion yes;
        allow-recursion { any; };
        allow-transfer { none; };
        allow-update { none; };
        auth-nxdomain no;
        dnssec-validation no;
        forward first;
        forwarders {
          114.114.114.114;
          8.8.8.8;
        };
};

zone "example.com" IN {
  type master;
  file "/var/lib/bind/example.com.zone";
};

zone "72.168.192.in-addr.arpa" IN {
  type master;
  file "/var/lib/bind/72.168.192.in-addr.arpa";
};
EOF

#创建正向解析配置文件


cat >/var/lib/bind/example.com.zone<<'EOF'
$TTL 1W
@   IN    SOA    ns1.example.com.    root (
                 2019070700        ; serial
                 3H                ; refresh (3 hours)
                 30M               ; retry (30 minutes)
                 2W                ; expiry (2 weeks)
                 1W )              ; minimum (1 week)
    IN    NS     ns1.example.com.
    IN    MX 10  smtp.example.com.
;
ns1.example.com.            IN A 192.168.72.20
smtp.example.com.           IN A 192.168.72.20
;
registry.example.com.       IN A 192.168.72.20
api.okd4.example.com.       IN A 192.168.72.20
api-int.okd4.example.com.   IN A 192.168.72.20
;
*.apps.okd4.example.com.    IN A 192.168.72.20
;
bastion.okd4.example.com.   IN A 192.168.72.20
bootstrap.okd4.example.com. IN A 192.168.72.21
;
master0.okd4.example.com.   IN A 192.168.72.22
master1.okd4.example.com.   IN A 192.168.72.23
master2.okd4.example.com.   IN A 192.168.72.24
;
worker0.okd4.example.com.   IN A 192.168.72.25
worker1.okd4.example.com.   IN A 192.168.72.26
EOF

#创建反向解析配置文件

cat >/var/lib/bind/72.168.192.in-addr.arpa<<'EOF'
$TTL 1W
@   IN    SOA      ns1.example.com.     root (
                   2019070700        ; serial
                   3H                ; refresh (3 hours)
                   30M               ; retry (30 minutes)
                   2W                ; expiry (2 weeks)
                   1W )              ; minimum (1 week)
    IN    NS       ns1.example.com.
;
20.72.168.192.in-addr.arpa. IN PTR api.okd4.example.com.
20.72.168.192.in-addr.arpa. IN PTR api-int.okd4.example.com.
;
20.72.168.192.in-addr.arpa. IN PTR bastion.okd4.example.com.

21.72.168.192.in-addr.arpa. IN PTR bootstrap.okd4.example.com.
;
22.72.168.192.in-addr.arpa. IN PTR master0.okd4.example.com.
23.72.168.192.in-addr.arpa. IN PTR master1.okd4.example.com.
24.72.168.192.in-addr.arpa. IN PTR master2.okd4.example.com.
;
25.72.168.192.in-addr.arpa. IN PTR worker0.okd4.example.com.
26.72.168.192.in-addr.arpa. IN PTR worker1.okd4.example.com.
EOF

 podman run -d --name bind9 \
   --restart always \
   --name=bind9 \
   -e TZ=Asia/Shanghai \
   --publish 192.168.14.160:53:53/udp \
   --publish 192.168.14.160:53:53/tcp \
   --publish 192.168.14.160:953:953/tcp \
   --volume /etc/bind:/etc/bind \
   --volume /var/cache/bind:/var/cache/bind \
   --volume /var/lib/bind:/var/lib/bind \
   --volume /var/log/bind:/var/log \
   internetsystemsconsortium/bind9:9.18
