#!/bin/bash -eux

apt-get update
apt-get install -qqy curl

echo "${1}" > /etc/hostname ; hostname `cat /etc/hostname`

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

curl -sL https://raw.githubusercontent.com/tsuru/now/master/run.bash > /tmp/install_node.sh
su - vagrant -c "/bin/bash /tmp/install_node.sh --template dockerfarm --host-ip ${2}"

cat << EOS >> ~vagrant/.bashrc

dbash() {
  docker exec -ti \${1} bash
}

EOS

apt-get autoremove -y
