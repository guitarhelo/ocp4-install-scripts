#!/bin/bash
sudo mkdir -p /opt/ibm/ocp4-install
sudo cd /opt/ibm/ocp4-install
wget https://cloud.redhat.com/openshift/install/pull-secret

$ echo -n john:Pass@2014 |base64
am9objpQYXNzQDIwMTQ=


$ echo -n admin:ewell@123 |base64

YWRtaW46ZXdlbGxAMTIz
cat pull-secret | jq . > ./pull-secret.json



 "registry.ocp4.ewell.cc": {
     "auth": "YWRtaW46ZXdlbGxAMTIz",
     "email": ""


#Edit new file
 "auths": {
   "registry.openshift4.example.com": {
     "auth": "am9objpQYXNzQDIwMTQ=",
     "email": "jingping.pan@ibm.com"
 },


cat >pull-secret-local.json<<EOF
{
    "auths":{
        "registry.example.com:8443":{
            "auth":"am9objpQYXNzQDIwMTQ=",
            "email":""
        }
    }
}
EOF

cat >pull-secret-local.json<<EOF
{
    "auths":{
        "registry.ocp4.ewell.cc":{
            "auth":"YWRtaW46ZXdlbGxAMTIz",
            "email":""
        }
    }
}
EOF


"auths":{
        "registry.ocp4.universalchain.com.cn:8443":{
            "auth":"am9objpQYXNzQDIwMTQ=",
            "email":""
        }
    }


LOCAL_SECRET_JSON='./pull-secret.json'
PRODUCT_REPO='openshift-release-dev'
RELEASE_NAME="ocp-release"
OCP_RELEASE=4.11.3
ARCHITECTURE=x86_64
LOCAL_REGISTRY=registry.openshift4.example.com
LOCAL_REPOSITORY=ocp4/openshift4
oc adm release mirror -a ${LOCAL_SECRET_JSON} --insecure \
 --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-${ARCHITECTURE} \
 --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} \
 --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-${ARCHITECTURE}




#To use the new mirrored repository to install, add the following section to the install-config.yaml:

imageContentSources:
- mirrors:
  - registry.openshift4.example.com/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-release
- mirrors:
  - registry.openshift4.example.com/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-v4.0-art-dev


#To use the new mirrored repository for upgrades, use the following to create an ImageContentSourcePolicy:

apiVersion: operator.openshift.io/v1alpha1
kind: ImageContentSourcePolicy
metadata:
  name: example
spec:
  repositoryDigestMirrors:
  - mirrors:
    - registry.openshift4.example.com/ocp4/openshift4
    source: quay.io/openshift-release-dev/ocp-release
  - mirrors:
    - registry.openshift4.example.com/ocp4/openshift4
    source: quay.io/openshift-release-dev/ocp-v4.0-art-dev