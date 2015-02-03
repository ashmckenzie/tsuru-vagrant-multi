#!/bin/bash -eux

TSURU_MODE="${1}"
TSURU_NOW_SCRIPT_URL="https://raw.githubusercontent.com/tsuru/now/master/run.bash"
TSURU_NOW_HOOK_URL="https://raw.githubusercontent.com/tsuru/tsuru/master/misc/git-hooks/pre-receive.archive-server"

export DEBIAN_FRONTEND="noninteractive"

echo "main" > /etc/hostname ; hostname `cat /etc/hostname`

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

sed -i 's/\/archive.ubuntu.com/\/au.archive.ubuntu.com/' /etc/apt/sources.list

apt-get update
apt-get install -y linux-image-extra-`uname -r` curl

cat << EOS > /etc/default/docker
DOCKER_OPTS="\$DOCKER_OPTS -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --insecure-registry=192.168.50.4:3030 --storage-driver=aufs"
EOS

cat << EOS > /etc/rc.local
#!/bin/sh -e

mkdir /var/run/registry && chown registry /var/run/registry && chmod 2755 /var/run/registry

exit 0
EOS

# HACK to get the system up and running
#
mkdir /var/run/registry && chmod 2777 /var/run/registry

curl -sL ${TSURU_NOW_SCRIPT_URL} > /tmp/install_main.sh
sudo -iu $SUDO_USER DEBIAN_FRONTEND=noninteractive /bin/bash /tmp/install_main.sh \
    --tsuru-pkg-${TSURU_MODE} \
    --archive-server \
    --hook-url ${TSURU_NOW_HOOK_URL} \
    --hook-name pre-receive \
    --template server

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
