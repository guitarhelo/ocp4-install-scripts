openshift-install wait-for bootstrap-complete --dir=rbohne

# Power off bootstrap
govc vm.power -off bootstrap.rbohne.lab.example.com

# Watch for pending csr and approve it for nodes
#    two for each node
oc get csr | awk '/Pending/ { print $1 }' | xargs oc adm certificate approve


openshift-install wait-for install-complete --dir=rbohne
