#!/bin/bash
cat > install-config.yaml <<EOF
apiVersion: v1
baseDomain: lab.example.com
compute:
- hyperthreading: Enabled
  name: worker
  replicas: 0
controlPlane:
  hyperthreading: Enabled
  name: master
  replicas: 3
metadata:
  name: rbohne
platform:
  none: {}
fips: false
pullSecret: '$( cat /data/software/ocp4-install/pull-secret.json )'
sshKey: '$( cat ~/.ssh/id_rsa.pub )'
EOF
