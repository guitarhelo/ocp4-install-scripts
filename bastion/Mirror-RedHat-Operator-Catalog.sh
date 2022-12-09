#Build the catalog for redhat-operators
oc adm catalog build --appregistry-org redhat-operators \
  --from=registry.redhat.io/redhat/redhat-operator-index:v4.6 \
  --to=${LOCAL_REGISTRY}/olm/redhat-operators:v4.6 \
  --registry-config=${LOCAL_SECRET_JSON} \
  --filter-by-os="linux/amd64" --insecure

#Mirror the catalog for redhat-operators
  oc adm catalog mirror ${LOCAL_REGISTRY}/olm/redhat-operators:v4.6 ${LOCAL_REGISTRY}/olm \
  --registry-config=${LOCAL_SECRET_JSON} --insecure

#Disable the default OperatorSources by adding disableAllDefaultSources:true to the spec file for the Operator Hub.

  oc login https://api.mycluster.example.com:6443 -u kubeadmin -p xxxx-xxxx-xxxx-xxxx
  oc patch OperatorHub cluster --type json -p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'



  $ cd manifests-redhat-operators-1615353468
  $ oc create -f imageContentSourcePolicy.yaml -f catalogSource.yaml
  #imagecontentsourcepolicy.operator.openshift.io/redhat-operators created
  #catalogsource.operators.coreos.com/redhat-operators created
  $ oc get pods,catalogsource -n openshift-markerplace
 # NAME                                        READY   STATUS    RESTARTS   AGE
 # pod/marketplace-operator-5d59977875-wgbdd   1/1     Running   0          110m
 # pod/redhat-operators-4zdl5                  1/1     Running   0          38s

  NAME                                                  DISPLAY   TYPE   PUBLISHER   AGE
  catalogsource.operators.coreos.com/redhat-operators             grpc               38s
