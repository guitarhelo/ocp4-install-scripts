.:53 {
    template IN A apps.ocp4.ewell.cc {
        match .*apps\.ocp4\.ewell\.cc
        answer "{{ .Name }} 60 IN A 192.168.14.160"
        fallthrough
    }
   hosts {
        192.168.14.160  registry.ocp4.ewell.cc
        192.168.14.160  bastion.ocp4.ewell.cc

        fallthrough
    }

    prometheus
    cache 160
    loadbalance
    forward . 114.114.114.114 10.128.57.21 223.5.5.5 223.6.6.6 8.8.8.8
    log

}
ewell.cc:53 {
    log
    errors
    file /etc/coredns/db.ewell.cc
}
150.168.192.in-addr.arpa {
    log
    errors
    file /etc/coredns/db.192.168.150
}






dig +noall +answer @192.168.150.232 registry.ocp4.ewell.cc
dig +noall +answer @192.168.150.232 api.ocp4.ewell.cc
dig +noall +answer @192.168.150.232 api-int.ocp4.ewell.cc
dig +noall +answer @192.168.150.232 console-openshift-console.apps.ocp4.ewell.cc
dig +noall +answer @192.168.150.232 bootstrap.ocp4.ewell.cc
dig +noall +answer @192.168.150.232 master0.ocp4.ewell.cc
dig +noall +answer @192.168.150.232 master1.ocp4.ewell.cc
dig +noall +answer @192.168.150.232 master2.ocp4.ewell.cc
dig +noall +answer @192.168.150.232 worker0.ocp4.ewell.cc
dig +noall +answer @192.168.150.232 worker1.ocp4.ewell.cc
