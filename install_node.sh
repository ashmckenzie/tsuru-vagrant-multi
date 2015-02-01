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

cat << EOS > /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

mkdir /var/run/registry && chown registry /var/run/registry

exit 0
EOS

apt-get autoremove -y
