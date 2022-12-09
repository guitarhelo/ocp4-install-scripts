#!/bin/bash
basedomain="ewell.cc"
clustername="ocp4"
ignitions_url = "http://192.168.150.132/ign"
nameserver  = "192.168.150.232"
nodes=(
    "bootstrap.${clustername}.${basedomain}"
    "master-0.${clustername}.${basedomain}"
    "master-1.${clustername}.${basedomain}"
    "master-2.${clustername}.${basedomain}"
    "worker-1.${clustername}.${basedomain}"
    "worker-2.${clustername}.${basedomain}"
    "worker-3.${clustername}.${basedomain}"
)

ignitions=(
    "$(ignitions_url)/bootstrap.ign"
    "$(ignitions_url)/master1.ign"
    "$(ignitions_url)/master2.ign"
    "$(ignitions_url)/master3.ign"
    "$(ignitions_url)/worker1.ign"
    "$(ignitions_url)/worker2.ign"
    "$(ignitions_url)/worker3.ign"
);

ips=(
    "ip=192.168.100.152::192.168.100.148:255.255.255.0:bootstrap.${clustername}.${basedomain}:ens192:none nameserver=192.168.150.232"
    "ip=192.168.100.149::192.168.100.148:255.255.255.0:master-0.${clustername}.${basedomain}:ens192:none nameserver=192.168.150.232"
    "ip=192.168.100.150::192.168.100.148:255.255.255.0:master-1.${clustername}.${basedomain}:ens192:none nameserver=192.168.150.232"
    "ip=192.168.100.151::192.168.100.148:255.255.255.0:master-2.${clustername}.${basedomain}:ens192:none nameserver=192.168.150.232"
    "ip=192.168.100.153::192.168.100.148:255.255.255.0:worker-1.${clustername}.${basedomain}:ens192:none nameserver=192.168.150.232"
    "ip=192.168.100.154::192.168.100.148:255.255.255.0:worker-2.${clustername}.${basedomain}:ens192:none nameserver=192.168.150.232"
    "ip=192.168.100.155::192.168.100.148:255.255.255.0:worker-3.${clustername}.${basedomain}:ens192:none nameserver=192.168.150.232"
)
  # generate boot iso for  vm's
for (( i=0; i< ${#nodes[@]} ; i++ )) ; do
      node=${nodes[$i]}
      ip=${ips[$i]}
      ignition=${ignitions[$i]}

      echo "Setup $node -> $ip";
  coreos-installer iso customize rhos-live.iso \
  --live-karg-append="rd.neednet=1" --live-karg-append="coreos.inst.install_dev=/dev/sda" \
  --live-karg-append="ip=10.39.0.245::10.39.0.254:255.255.255.0:boostrap.ocp4.ewell.cc:ens192:none" \
  --live-karg-append="coreos.inst.ignition_url=http://10.39.0.244:8080/master.ign" \
  --live-karg-append="nameserver=10.32.140.170" \
  --live-karg-append="nameserver=10.40.2.230"
done;