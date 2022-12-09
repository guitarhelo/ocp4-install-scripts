#!/usr/bin/env bash
cd /data/software/iso_custom
tar xfv rhcos-vmware.x86_64.ova
yum install qemu-img
qemu-img convert -f vmdk -O raw disk.vmdk disk.raw
fdisk -l disk.raw
#mkdir /mnt/boot
# offset =start *512
mount -o loop,offset=1048576 disk.raw /mnt/boot
mkdir -p iso/boot/grub
cp /mnt/grub2/grub.cfg iso/boot/grub
#方法1
#vi /mnt/grub2/grub.cfg change and add below line to
set ignition_network_kcmdline='rd.neednet=1 ip=192.168.122.10::192.168.122.1:255.255.255.0:myhost:ens192:none nameserver=192.168.122.1'
umount /mnt/boot
yum install grub2-pc-modules grub2-efi-x64-modules
yum install xorriso mtools
#if have issue to install you can
#sudo mount -o loop /data/software/rhel-8.6-x86_64-dvd.iso /mnt/disc
grub2-mkrescue -o staticip.iso iso

#方法2：
yum module install rust-toolset

coreos-installer iso customize --live-karg-append rd.neednet=1 coreos.inst.install_dev=/dev/sda coreos.inst.ignition_url=http://10.39.1.244:8080/master.ign ip=10.39.1.246::10.39.1.254:255.255.255.0:tsczocptsmaster02.ocp4dev.trinasolar.com:ens192:none nameserver=10.32.140.170  nameserver=10.40.2.230
    -o custom.iso \
    rhcos-live.x86_64.iso