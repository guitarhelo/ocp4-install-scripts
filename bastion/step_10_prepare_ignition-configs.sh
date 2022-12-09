#!/bin/bash
#enerate the Kubernetes manifests for the cluster
./openshift-install create manifests --dir /opt/openshift


./openshift-install create ignition-configs --dir /opt/openshift

