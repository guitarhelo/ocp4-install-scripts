#!/bin/bash
dig +noall +answer @192.168.14.160  bootstrap.ocp4.example.com
dig +noall +answer @192.168.14.160  api.ocp4.example.com
dig +noall +answer @192.168.14.160  api-int.ocp4.example.com
dig +noall +answer @192.168.14.160  worker0.ocp4.example.com
dig +noall +answer @192.168.14.160  worker1.ocp4.example.com
dig +noall +answer @192.168.14.160  master0.ocp4.example.com
dig +noall +answer @192.168.14.160  worker1.ocp4.example.com
dig +noall +answer @192.168.14.160  worker2.ocp4.example.com