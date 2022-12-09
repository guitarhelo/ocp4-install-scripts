#!/bin/bash
#upload iso file to vcenter datastore
#mount iso start from cdrom

mkdir -p /root/.kube
cp /opt/openshift/auth/kubeconfig ~/.kube/config
#start boot node
openshift-install --dir=/opt/openshift wait-for bootstrap-complete --log-level=debug
#DEBUG OpenShift Installer 4.10.0-0.okd-2022-03-07-131213
#......

#start master0,master1,master2


oc get csr
oc get csr -o go-template='{{range .items}}{{if not .status}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}' | xargs --no-run-if-empty oc adm certificate approve

ssh core@bootstrap "journalctl -xe"

openshift-install --dir=./ wait-for install-complete | tee install-complete