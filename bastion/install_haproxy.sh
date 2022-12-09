#!/bin/bash
mkdir -p /etc/haproxy
cat >/etc/haproxy/haproxy.cfg<<EOF
global
  log         127.0.0.1 local2
  maxconn     4000
  daemon
defaults
  mode                    http
  log                     global
  option                  dontlognull
  option http-server-close
  option                  redispatch
  retries                 3
  timeout http-request    10s
  timeout queue           1m
  timeout connect         10s
  timeout client          1m
  timeout server          1m
  timeout http-keep-alive 10s
  timeout check           10s
  maxconn                 3000
frontend stats
  bind *:1936
  mode            http
  log             global
  maxconn 10
  stats enable
  stats hide-version
  stats refresh 30s
  stats show-node
  stats show-desc Stats for openshift cluster
  stats auth admin:openshift
  stats uri /stats

frontend openshift-api-server
    bind *:6443
    default_backend openshift-api-server
    mode tcp
    option tcplog
backend openshift-api-server
    balance source
    mode tcp
    server bootstrap 192.168.72.21:6443 check
    server master0 192.168.72.22:6443 check
    server master1 192.168.72.23:6443 check
    server master2 192.168.72.24:6443 check
frontend machine-config-server
    bind *:22623
    default_backend machine-config-server
    mode tcp
    option tcplog
backend machine-config-server
    balance source
    mode tcp
    server bootstrap 192.168.72.21:22623 check
    server master0 192.168.72.22:22623 check
    server master1 192.168.72.23:22623 check
    server master2 192.168.72.24:22623 check
frontend ingress-http
    bind *:80
    default_backend ingress-http
    mode tcp
    option tcplog
backend ingress-http
    balance source
    mode tcp
    server worker0 192.168.72.25:80 check
    server worker1 192.168.72.26:80 check
frontend ingress-https
    bind *:443
    default_backend ingress-https
    mode tcp
    option tcplog
backend ingress-https
    balance source
    mode tcp
    server worker0 192.168.72.25:443 check
    server worker1 192.168.72.26:443 check
EOF
podman run -d --name haproxy \
  --restart always \
  -p 1936:1936 \
  -p 6443:6443 \
  -p 22623:22623 \
  -p 80:80 -p 443:443 \
  --sysctl net.ipv4.ip_unprivileged_port_start=0 \
  -v /etc/haproxy/:/usr/local/etc/haproxy:ro \
  haproxy:2.5.5-alpine3.15

podman generate systemd --new haproxy > /etc/systemd/system/haproxy.service
systemctl enable haproxy.service
systemctl restart haproxy.service
systemctl status haproxy.service
