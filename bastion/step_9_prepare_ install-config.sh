#!/bin/bash
mkdir -p /opt/openshift

cat > install-config.yaml <<EOF
apiVersion: v1
baseDomain: example.com
compute:
- hyperthreading: Disabled
  name: worker
  replicas: 0
controlPlane:
  hyperthreading: Disabled
  name: master
  replicas: 3
metadata:
  name: ocp4
networking:
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  none: {}
fips: false
pullSecret: >-
  '$( cat /opt/harbor/tools/pull-secret.json )'
sshKey: >-
  '$( cat ~/.ssh/id_rsa.pub )'
imageContentSources:
- mirrors:
  - registry.ocp4.example.com:5000/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-release
- mirrors:
  - registry.ocp4.example.com:5000/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
additionalTrustBundle: >-
  '$( cat /opt/harbor/cert/ca.crt)'
EOF

#sudo apt-get install yamllint // ubuntu
sudo dnf install yamllint // Linux
yamllint install_config.yaml

#method  2

export CLUSTER_NAME="test-cluster"
export CLUSTER_DOMAIN="example.com"
cat > install-config.yaml << EOF
apiVersion: v1
baseDomain: ${CLUSTER_DOMAIN}
controlPlane:
  name: master
  hyperthreading: Disabled
  replicas: 3
compute:
- name: worker
  hyperthreading: Disabled
  replicas: 3
metadata:
  name: ${CLUSTER_NAME}
networking:
  clusterNetworks:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  machineNetwork:
  - cidr: 172.18.0.0/16
  networkType: OpenShiftSDN
  serviceNetwork:
  - 172.30.0.0/16
platform:
  none: {}
fips: false
EOF

# add the registry pull-secret
REG_SECRET=`echo -n 'myuser:mypassword' | base64 -w0`
echo -n "pullSecret: '" >> install-config.yaml
echo '{ "auths": {}}' | jq '.auths += {"registry:5000": {"auth": "REG_SECRET","email": "me@working.me"}}' | sed "s/REG_SECRET/$REG_SECRET/" | jq -c . | sed "s/$/\'/g" >> install-config.yaml

#Attaching the ssh key:
echo -n "sshKey: '" >> install-config.yaml && cat ~/.ssh/id_rsa.pub | sed "s/$/\'/g" >> install-config.yaml
#Adding the Registry CA:
echo "additionalTrustBundle: |" >> install-config.yaml
cat ca.crt | sed 's/^/\ \ \ \ \ /g' >> install-config.yaml

#And finally, adding the “imageContentSources” extension :
cat ${REGISTRY_BASE}/downloads/secrets/mirror-output.txt | grep -A7 imageContentSources >> install-config.yaml