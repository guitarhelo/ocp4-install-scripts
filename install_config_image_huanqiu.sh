To use the new mirrored repository to install, add the following section to the install-config.yaml:

imageContentSources:
- mirrors:
  - registry.ocp4.universalchain.com.cn:8443/ocp4/openshift4.10
  source: quay.io/openshift-release-dev/ocp-release
- mirrors:
  - registry.ocp4.universalchain.com.cn:8443/ocp4/openshift4.10
  source: quay.io/openshift-release-dev/ocp-v4.0-art-dev


To use the new mirrored repository for upgrades, use the following to create an ImageContentSourcePolicy:

apiVersion: operator.openshift.io/v1alpha1
kind: ImageContentSourcePolicy
metadata:
  name: example
spec:
  repositoryDigestMirrors:
  - mirrors:
    - registry.ocp4.universalchain.com.cn:8443/ocp4/openshift4.10
    source: quay.io/openshift-release-dev/ocp-release
  - mirrors:
    - registry.ocp4.universalchain.com.cn:8443/ocp4/openshift4.10
    source: quay.io/openshift-release-dev/ocp-v4.0-art-dev