#配置oc命令补全
oc completion bash > oc_completion.sh
cat >>.bashrc <<EOF
source ~/oc_completion.sh
EOF


#确认harbor运行状态正常
docker-compose ps

#为集群节点 SSH 访问生成密钥对
ssh-keygen -t rsa -b 4096 -N '' -f ~/.ssh/id_rsa
#启动 ssh-agent 进程为后台任务
eval "$(ssh-agent -s)"
#将 SSH 私钥添加到 ssh-agent
ssh-add ~/.ssh/id_rsa

#为集群生成 Kubernetes 清单
cd /opt/openshift/
openshift-install create manifests --dir=/opt/openshift
