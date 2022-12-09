dig @localhost ns1.ewell.if [[ $? == 0 ]]; then
    echo "Succeed"
else
    echo "Failed"
fi

#A记录
api.ocp4dev IN  A   10.39.1.244
api-int.ocp4dev IN  A   10.39.1.244
*.apps.ocp4dev  IN  A   10.39.1.244

bastion.ocp4dev    IN  A   10.39.1.244
master01.ocp4dev   IN  A   10.39.1.245
master02.ocp4dev   IN  A   10.39.1.246
master03.ocp4dev   IN  A   10.39.1.247
worker01.ocp4dev   IN  A   10.39.1.248
worker02.ocp4dev   IN  A   10.39.1.249
worker03.ocp4dev   IN  A   10.39.1.250
worker04.ocp4dev   IN  A   10.39.1.251
worker05.ocp4dev   IN  A   10.39.1.252
worker06.ocp4dev   IN  A   10.39.1.253



oauth-openshift.apps.ocp4.ewell.cc IN  A   10.39.1.244
console-openshift-console.apps.ocp4.ewell.cc IN    A   10.39.1.244
alertmanager-main-openshift-monitoring.apps.ocp4.ewell.cc IN   A   10.39.1.244
grafana-openshift-monitoring.apps.ocp4.ewell.cc IN A   10.39.1.244
prometheus-k8s-openshift-monitoring.apps.ocp4.ewell.cc IN  A   10.39.1.244
thanos-querier-openshift-monitoring.apps.ocp4.ewell.cc IN  A   10.39.1.244



#PTR记录
10.39.1.244 IN  PTR api.ocp4
10.39.1.244 IN  PTR api-int.ocp4dev

10.39.1.244 IN  PTR bastion.ocp4dev
10.39.1.245 IN  PTR master01.ocp4dev
10.39.1.246 IN  PTR master02.ocp4dev
10.39.1.247 IN  PTR master03.ocp4dev
10.39.1.248 IN  PTR worker01.ocp4dev
10.39.1.249 IN  PTR worker02.ocp4dev
10.39.1.250 IN  PTR worker03.ocp4dev
10.39.1.251 IN  PTR worker04.ocp4dev
10.39.1.252 IN  PTR worker05.ocp4dev
10.39.1.253 IN  PTR worker06.ocp4dev
