wget https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz
tar -zxvf cloudctl-linux-amd64.tar.gz
chmod 755 cloudctl-linux-amd64
mv cloudctl-linux-amd64 /usr/local/bin/cloudctl
cloudctl -v
yum -y install skopeo

#create registry namespace
export CASE_NAME=ibm-integration-platform-navigator
export CASE_VERSION=1.7.3
export CASE_ARCHIVE=${CASE_NAME}-${CASE_VERSION}.tgz
export CASE_INVENTORY_SETUP=platformNavigatorOperator
export OFFLINEDIR=/data/software/cp4i-offline
export CASE_REPO_PATH=https://github.com/IBM/cloud-pak/raw/master/repo/case

cloudctl case save --repo $CASE_REPO_PATH --case $CASE_NAME --version $CASE_VERSION --outputdir $OFFLINEDIR
