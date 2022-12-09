

Bash auto completion

To make our life easier the tools are been deployed with a set os templates to enable use to use those tools with bash auto completion.
To generate the bash auto completion scripts run the following command :

$ yum install -y bash-completion.noarch bash-completion-extras.noarch$ oc completion bash > /etc/bash_completion.d/oc$ openshift-install completion bash > /etc/bash_completion.d/openshift-install
(Log out and Login for usage)


ssh ‐i ~/.ssh/id_rsa core@bootstrap.ocp4.ewell.cc
openshift-install --dir /opt/openshift wait-for bootstrap-complete --log-level=info
 journalctl ‐b ‐f ‐u release‐image.service ‐u bootkube.service


