#!/bin/bash

OCP_RELEASE=4.10.16
LOCAL_REGISTRY='registry.ewell.cc'
LOCAL_REPOSITORY='ocp4/openshift4
PRODUCT_REPO='openshift-release-dev'
LOCAL_SECRET_JSON='/opt/ocp4_install/pull-sceret.json'
RELEASE_NAME="ocp-release"
ARCHITECTURE='x86_64'
REMOVABLE_MEDIA_PATH='/data/ocp-image'

oc adm release mirror -a ${LOCAL_SECRET_JSON} \
--from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE}-
${ARCHITECTURE} \
--to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} \
--to-release-
image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}-
${ARCHITECTURE} --dry-run