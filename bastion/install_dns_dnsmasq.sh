#!/usr/bin/env bash
yum install tmux -y
yum install -y dnsmasq

cat > /etc/dnsmasq.d/openshift-4.conf <<EOF
strict-order
domain=rbohne.lab.example.com
expand-hosts
server=10.19.143.247
# except-interface=lo
# bind-dynamic
interface=ens224
address=/apps.rbohne.lab.example.com/192.168.100.148
addn-hosts=/etc/dnsmasq-openshift-4.addnhosts
EOF

cat > /etc/dnsmasq-openshift-4.addnhosts <<EOF
192.168.100.148 api.rbohne.lab.example.com api-int.rbohne.lab.example.com
192.168.100.149 master-0.rbohne.lab.example.com etcd-0.rbohne.lab.example.com
192.168.100.150 master-1.rbohne.lab.example.com etcd-1.rbohne.lab.example.com
192.168.100.151 master-2.rbohne.lab.example.com etcd-2.rbohne.lab.example.com
192.168.100.152 bootstrap.rbohne.lab.example.com
192.168.100.153 worker-1.rbohne.lab.example.com
192.168.100.154 worker-2.rbohne.lab.example.com
192.168.100.155 worker-3.rbohne.lab.example.com
EOF


systemctl enable --now dnsmasq
systemctl status dnsmasq

firewall-cmd --zone=public --permanent --add-service=dns
firewall-cmd --reload
