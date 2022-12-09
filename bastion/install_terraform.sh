#!/bin/bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo dnf repolist
sudo yum -y install terraform
yum --showduplicate list terraform
terraform  version