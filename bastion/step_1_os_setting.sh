#!/bin/bash
#主机名称

sudo su -  #切换root
hostnamectl set-hostname bastion.ocp4.ewell.cc

systemctl stop firewalld
systemctl disable firewalld
#编辑dns
vi /etc/resolv.conf
nameserver 114.114.114.114
nameserver 10.128.57.21
nameserver 223.5.5.5
nameserver 223.6.6.6
nameserver 8.8.8.8

#selinux设置
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

#关闭防火墙
systemctl disable firewalld
systemctl stop firewalld

#操作系统参数优化
sysctl vm.max_map_count
echo "vm.max_map_count=262144" >> /etc/sysctl.conf

#echo "vm.max_map_count=262144" | tee -a /etc/sysctl.conf


sysctl -p
sysctl vm.max_map_count
cat /etc/sysctl.conf

#查看端口范围
sysctl net.ipv4.ip_local_port_range
 #如果超过如下配置，则不需要设置，比如返回
net.ipv4.ip_local_port_range = 32768 60999
#否则执行
echo 'net.ipv4.ip_local_port_range="10240 60999"' >> /etc/sysctl.conf
#使配置生效
sysctl -p
#增加操作系统打开文件句柄数
ulimit -a
ulimit -n 10240
ulimit -a
vi /etc/security/limits.conf
* soft nofile 10240
* hard nofile 10240
#关闭内存交换
swapoff -a
#将 swap 那一行注释掉 vi /etc/fstab #/dev/mapper/rhel-swap

#配置内核参数
$ modprobe br_netfilter     #加载内核模块（临时）
$ cat > /etc/sysctl.conf << EOF
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
$ sysctl -p

