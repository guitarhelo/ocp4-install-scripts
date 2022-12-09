#!/bin/bash

#in fodora

dnf install coreos-installer

#sample for create custom iso
rd.neednet=1
coreos.inst.install_dev=/dev/sda
coreos.inst.ignition_url=http://192.168.14.160:8088/boostrap.ign
ip=192.168.14.161::192.168.14.2::255.255.255.0:tsczocpuatmaster01.ocp4uat.trinasolar.com:ens192:none
nameserver=192.168.14.160
nameserver=114.114.114.114

coreos-installer iso customize rhos-live.iso \
--live-karg-append="rd.neednet=1" --live-karg-append="coreos.inst.install_dev=/dev/sda" \
--live-karg-append="ip=192.168.14.161::192.168.14.2:255.255.255.0:boostrap.ocp4.example.com:ens192:none" \
--live-karg-append="coreos.inst.ignition_url=http://192.168.14.160:8088/boostrap.ign" \
--live-karg-append="nameserver=192.168.14.160" \
--live-karg-append="nameserver=114.114.114.114"
-o rhos-boostrap-live.iso
#delete
coreos-installer iso customize rhcos-live-boot.x86_64.iso -f \
--live-karg-append="rd.neednet=1" --live-karg-append="coreos.inst.install_dev=/dev/sda" \
--live-karg-append="ip=192.168.14.161::192.168.14.2:255.255.255.0:bootstrap.ocp4.example.com:ens192:none" \
--live-karg-append="coreos.inst.ignition_url=http://192.168.14.160:8088/bootstrap.ign" \
--live-karg-append="nameserver=192.168.14.160" \
--live-karg-append="nameserver=114.114.114.114" \
-o bootstrap.iso
#master

coreos-installer iso customize rhcos-live-boot.x86_64.iso \
--live-karg-append="rd.neednet=1" --live-karg-append="coreos.inst.install_dev=/dev/sda" \
--live-karg-append="ip=192.168.14.161::192.168.14.2:255.255.255.0:boostrap.ocp4.example.com:ens192:none" \
--live-karg-append="coreos.inst.ignition_url=http://192.168.14.160:8088/boostrap.ign" \
--live-karg-append="nameserver=192.168.14.160" \
--live-karg-append="nameserver=114.114.114.114"


coreos-installer iso customize temp.iso -f \
--live-karg-delete="rd.neednet=1" --live-karg-append="coreos.inst.install_dev=/dev/sda" \
--live-karg-delete="ip=192.168.14.161::192.168.14.2:255.255.255.0:boostrap.ocp4.example.com:ens192:none" \
--live-karg-delete="coreos.inst.ignition_url=http://192.168.14.160:8088/boostrap.ign" \
--live-karg-delete="nameserver=192.168.14.160" \
--live-karg-delete="nameserver=114.114.114.114" \
-o boot.iso

coreos-installer iso customize rhcos-live.x86_64.iso  \
--live-karg-append="rd.neednet=1" --live-karg-append="coreos.inst.install_dev=/dev/sda" \
--live-karg-append="ip=192.168.14.161::192.168.14.2:255.255.255.0:bootstrap.ocp4.example.com:ens192:none" \
--live-karg-append="coreos.inst.ignition_url=http://192.168.14.160:8088/ign/bootstrap.ign" \
--live-karg-append="nameserver=192.168.14.160" \
--live-karg-append="nameserver=114.114.114.114" \
-o boot.iso

coreos-installer iso customize rhcos-live.x86_64.iso -f \
--live-karg-append="rd.neednet=1" --live-karg-append="coreos.inst.install_dev=/dev/sda" \
--live-karg-append="ip=192.168.14.162::192.168.14.2:255.255.255.0:master0.ocp4.example.com:ens192:none" \
--live-karg-append="coreos.inst.ignition_url=http://192.168.14.160:8088/ign/master.ign" \
--live-karg-append="nameserver=192.168.14.160" \
--live-karg-append="nameserver=114.114.114.114" \
-o master0.iso

coreos-installer iso customize rhcos-live.x86_64.iso -f \
--live-karg-append="rd.neednet=1" --live-karg-append="coreos.inst.install_dev=/dev/sda" \
--live-karg-append="ip=192.168.14.163::192.168.14.2:255.255.255.0:master1.ocp4.example.com:ens192:none" \
--live-karg-append="coreos.inst.ignition_url=http://192.168.14.160:8088/ign/master.ign" \
--live-karg-append="nameserver=192.168.14.160" \
--live-karg-append="nameserver=114.114.114.114" \
-o master1.iso

coreos-installer iso customize rhcos-live.x86_64.iso -f \
--live-karg-append="rd.neednet=1" --live-karg-append="coreos.inst.install_dev=/dev/sda" \
--live-karg-append="ip=192.168.14.164::192.168.14.2:255.255.255.0:master2.ocp4.example.com:ens192:none" \
--live-karg-append="coreos.inst.ignition_url=http://192.168.14.160:8088/ign/master.ign" \
--live-karg-append="nameserver=192.168.14.160" \
--live-karg-append="nameserver=114.114.114.114" \
-o master2.iso

coreos-installer iso customize rhcos-live.x86_64.iso -f \
--live-karg-append="rd.neednet=1" --live-karg-append="coreos.inst.install_dev=/dev/sda" \
--live-karg-append="ip=192.168.14.165::192.168.14.2:255.255.255.0:worker0.ocp4.example.com:ens192:none" \
--live-karg-append="coreos.inst.ignition_url=http://192.168.14.160:8088/ign/worker.ign" \
--live-karg-append="nameserver=192.168.14.160" \
--live-karg-append="nameserver=114.114.114.114" \
-o worker0.iso
