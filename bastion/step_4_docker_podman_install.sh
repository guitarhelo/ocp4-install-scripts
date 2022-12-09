#!/bin/bash
sudo dnf install podman -y
podman -v
#sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y yum-utils
 #sudo yum-config-manager \
 #   --add-repo \
 #   https://download.docker.com/linux/rhel/docker-ce.repo

sudo yum-config-manager \
         --add-repo \
         https://download.docker.com/linux/centos/docker-ce.repo
#diabled the runc repo in order to solve the issue docker with podman on RH8
sudo dnf config-manager --set-disabled docker-ce-stable
sudo rpm --install --nodeps --replacefiles --excludepath=/usr/bin/runc https://download.docker.com/linux/centos/8/x86_64/stable/Packages/containerd.io-1.4.9-3.1.el8.x86_64.rpm
#enaled and install
sudo dnf install --enablerepo=docker-ce-stable docker-ce   -y
sudo dnf update
docker -v

#start and enable docker
systemctl daemon-reload
sudo systemctl start docker
sudo systemctl enable docker
#Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
## Giving permissions

sudo chmod +x /usr/local/bin/docker-compose#
# Test installation
docker-compose --version

yum-config-manager \
--add-repo \
http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
