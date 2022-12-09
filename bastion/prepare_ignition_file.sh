#生成ignitions文件
cat > install-config.yaml.temp <<EOF
apiVersion: v1
baseDomain: ewell.cc
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 0
controlPlane:
  hyperthreading: Enabled
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
pullSecret: '$( cat /data/software/ocp4_install/pull-secret.json )'
sshKey: '$( cat ~/.ssh/id_rsa.pub )'
imageContentSources:
- mirrors:
  - registry.ocp4.ewell.cc:5000/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-release
- mirrors:
  - registry.ocp4.ewell.cc:5000/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
additionalTrustBundle: '$( cat /opt/ibm/registry/certs/ca.crt)'
EOF

mkdir ocp
cp install-config.yaml ocp

openshift-install create manifests --dir=./
cd ocp/manifests
