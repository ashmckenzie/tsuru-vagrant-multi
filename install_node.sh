#!/bin/bash -eux

NODENAME="${1}"
TSURU_MAIN_IP="${2}"

apt-get update
apt-get install -qqy curl

echo "${NODENAME}" > /etc/hostname ; hostname `cat /etc/hostname`

cat << EOS > /etc/default/docker
"DOCKER_OPTS="\$DOCKER_OPTS -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --insecure-registry=192.168.50.4:3030 --storage-driver=aufs""
EOS

curl -sL https://raw.githubusercontent.com/tsuru/now/master/run.bash > /tmp/install_node.sh
su - vagrant -c "/bin/bash /tmp/install_node.sh --template dockerfarm --host-ip ${TSURU_MAIN_IP}"

if [ -d /usr/local/go ]; then
  export GOPATH=~vagrant/go
else
  export GOPATH=/usr/local/go
fi

mkdir -p $GOPATH

if [ -f ~vagrant/.bashrc ]; then
  if ! grep 'export GOPATH' ~vagrant/.bashrc; then
    echo "Adding GOPATH=$GOPATH to ~vagrant/.bashrc"
    echo -e "export GOPATH=$GOPATH" | tee -a ~vagrant/.bashrc > /dev/null
  fi
fi

cat << EOS >> ~vagrant/.bashrc

dbash() {
  docker exec -ti \${1} bash
}

EOS

apt-get autoremove -y
