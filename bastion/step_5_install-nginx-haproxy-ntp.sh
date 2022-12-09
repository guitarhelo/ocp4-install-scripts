#!/bin/bash


#in redhat7  vi /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=0
enabled=1

yum install haproxy -y
sudo dnf install nginx
setsebool -P nis_enabled 1
#vi /etc/nginx/nginx.conf change default port to 8080
systemctl enable nginx
systemctl start nginx

#nginx folder
mkdir -p /usr/share/nginx/html/ign
mkdir -p /usr/share/nginx/html/iso
#If you are using HAProxy as a load balancer and SELinux is set to
# enforcing, you must ensure that the HAProxy service can bind to
# the configured TCP port by running
setsebool -P haproxy_connect_any=1
#vi /etc/haproxy/haproxy.cfg
systemctl enable haproxy && systemctl restart haproxy


# for apache2
  dnf install httpd
  vi /etc/httpd/conf.d/welcome.conf
  #修改Options +Indexes
  #启动http并加入开机启动
  #systemctl start httpd && systemctl enable httpd
