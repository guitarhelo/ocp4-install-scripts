#!/bin/bash
sudo dnf install genisoimage

# extract govc binary to /usr/local/bin
# note: the "tar" command must run with root permissions
curl -L -o - "https://github.com/vmware/govmomi/releases/latest/download/govc_$(uname -s)_$(uname -m).tar.gz" | tar -C /usr/local/bin -xvzf - govc


mount rhcos-4.5.6-x86_64-installer.x86_64.iso /mnt/
mkdir /tmp/rhcos
rsync -a /mnt/* /tmp/rhcos/
cd /tmp/rhcos

#Edit isolinux/isolinux.cfg

label linux
  menu label ^Install Bootstrap
  kernel /images/vmlinuz
  append initrd=/images/initramfs.img nomodeset rd.neednet=1 coreos.inst=yes coreos.inst.install_dev=sda coreos.inst.image_url=http://192.168.14.38/ocp45/rhcos-4.5.2-x86_64-metal.x86_64.raw.gz coreos.inst.ignition_url=http://192.168.14.38/ocp45/bootstrap.ign ip=192.168.14.55::192.168.14.1:255.255.255.0:bootstrap.test.myocp.cluster:ens192:none nameserver=192.168.14.25

label linux
  menu label ^Install Master0
  kernel /images/vmlinuz
  append initrd=/images/initramfs.img nomodeset rd.neednet=1 coreos.inst=yes coreos.inst.install_dev=sda coreos.inst.image_url=http://192.168.14.38/ocp45/rhcos-4.5.2-x86_64-metal.x86_64.raw.gz coreos.inst.ignition_url=http://192.168.14.38/ocp45/master.ign ip=192.168.14.50::192.168.14.1:255.255.255.0:master0.test.myocp.cluster:ens192:none nameserver=192.168.14.25

label linux
  menu label ^Install Master1
  kernel /images/vmlinuz
  append initrd=/images/initramfs.img nomodeset rd.neednet=1 coreos.inst=yes coreos.inst.install_dev=sda coreos.inst.image_url=http://192.168.14.38/ocp45/rhcos-4.5.2-x86_64-metal.x86_64.raw.gz coreos.inst.ignition_url=http://192.168.14.38/ocp45/master.ign ip=192.168.14.51::192.168.14.1:255.255.255.0:master1.test.myocp.cluster:ens192:none nameserver=192.168.14.25

label linux
  menu label ^Install Master2
  kernel /images/vmlinuz
  append initrd=/images/initramfs.img nomodeset rd.neednet=1 coreos.inst=yes coreos.inst.install_dev=sda coreos.inst.image_url=http://192.168.14.38/ocp45/rhcos-4.5.2-x86_64-metal.x86_64.raw.gz coreos.inst.ignition_url=http://192.168.14.38/ocp45/master.ign ip=192.168.14.52::192.168.14.1:255.255.255.0:master2.test.myocp.cluster:ens192:none nameserver=192.168.14.25

label linux
  menu label ^Install Worker1
  kernel /images/vmlinuz
  append initrd=/images/initramfs.img nomodeset rd.neednet=1 coreos.inst=yes coreos.inst.install_dev=sda coreos.inst.image_url=http://192.168.14.38/ocp45/rhcos-4.5.2-x86_64-metal.x86_64.raw.gz coreos.inst.ignition_url=http://192.168.14.38/ocp45/worker.ign ip=192.168.14.53::192.168.14.1:255.255.255.0:worker1.test.myocp.cluster:ens192:none nameserver=192.168.14.25

label linux
  menu label ^Install Worker2
  kernel /images/vmlinuz
  append initrd=/images/initramfs.img nomodeset rd.neednet=1 coreos.inst=yes coreos.inst.install_dev=sda coreos.inst.image_url=http://192.168.14.38/ocp45/rhcos-4.5.2-x86_64-metal.x86_64.raw.gz coreos.inst.ignition_url=http://192.168.14.38/ocp45/worker.ign ip=192.168.14.54::192.168.14.1:255.255.255.0:worker2.test.myocp.cluster:ens192:none nameserver=192.168.14.25




#build iso template
genisoimage -U -A "RHCOS-x86_64" -V "RHCOS-x86_64" \
  -volset "RHCOS-x86_64" \
  -J -joliet-long -r -v -T -x ./lost+found \
  -o /tmp/rhcos-4.5.6-x86_64-installer-custom.x86_64.iso \
  -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  -no-emul-boot -boot-load-size 4 \
  -boot-info-table -eltorito-alt-boot \
  -e images/efiboot.img -no-emul-boot .
