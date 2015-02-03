#!/bin/bash -eux

NODENAME="${1}"
TSURU_MAIN_IP="${2}"

export DEBIAN_FRONTEND="noninteractive"

echo "${NODENAME}" > /etc/hostname ; hostname `cat /etc/hostname`

cat << EOS > /etc/apt/apt.conf.d/local
Dpkg::Options {
   "--force-confdef";
   "--force-confold";
}
EOS

cat << EOS > /etc/apt/apt.conf.d/95proxy
Acquire::http::proxy "http://10.1.1.1:3128";
Acquire::https::proxy "https://10.1.1.1:3128";
Acquire::ftp::proxy "http://10.1.1.1:3128";
EOS

sed -i 's/archive.ubuntu.com/au.archive.ubuntu.com/' /etc/apt/sources.list

apt-get update
apt-get install -y linux-image-extra-`uname -r` curl

cat << EOS > /etc/default/docker
export http_proxy="http://10.1.1.1:3128"
DOCKER_OPTS="\$DOCKER_OPTS -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --insecure-registry=192.168.50.4:3030 --storage-driver=aufs"
EOS

curl -sL https://raw.githubusercontent.com/tsuru/now/master/run.bash > /tmp/install_node.sh
su - vagrant -c "DEBIAN_FRONTEND=noninteractive /bin/bash /tmp/install_node.sh --template dockerfarm --host-ip ${TSURU_MAIN_IP}"

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
