#!/bin/bash
echo "begin to make local yum repository from ISO image file"
# shellcheck disable=SC1066
$mount_dir="/mnt/disc"
sudo mkdir -p $mount_dir
sudo mount -o loop /data/software/rhel-8.6-x86_64-dvd.iso /mnt/disc

cat << EOF > /etc/yum.repos.d/local.repo
[dvd-BaseOS]
name=DVD for RHEL - BaseOS
baseurl=file:///mnt/disc/BaseOS
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[dvd-AppStream]
name=DVD for RHEL - AppStream
baseurl=file:///mnt/disc/AppStream
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF

sudo yum clean all
sudo yum makecache
sudo yum repolist enabled

#开机自动挂载

将映射关系写到配置文件中 /etc/fstab

vim /etc/fstab

    1

#编辑文件内容在最下端添加

/data/software/rhel-8.6-x86_64-dvd.iso /mnt/disc  iso9660 loop,defaults 0 0
