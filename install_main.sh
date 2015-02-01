#!/bin/bash -eux

# Copyright 2014 tsuru authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# ENV["TSURU_BOOTSTRAP"] || "stable"
TSURU_MODE=$1

# E.g.: "https://raw.githubusercontent.com/tsuru/now/master/run.bash"
TSURU_NOW_SCRIPT_URL=$2

# E.g.: "https://raw.githubusercontent.com/tsuru/tsuru/master/misc/git-hooks/pre-receive.archive-server"
TSURU_NOW_HOOK_URL=$3

# E.g.: "" or "--tsuru-from-source"
TSURU_NOW_OPTIONS=$4

apt-get update
apt-get install -qqy curl

echo "main" > /etc/hostname ; hostname `cat /etc/hostname`

curl -sL ${TSURU_NOW_SCRIPT_URL} > /tmp/tsuru-now.bash
chmod +x /tmp/tsuru-now.bash
# sudo -iu vagrant /tmp/tsuru-now.bash --tsuru-pkg-stable --archive-server --hook-url https://raw.githubusercontent.com/tsuru/tsuru/master/misc/git-hooks/pre-receive.archive-server --hook-name pre-receive
sudo -iu $SUDO_USER \
  /tmp/tsuru-now.bash \
    --tsuru-pkg-${TSURU_MODE} \
    --archive-server \
    --hook-url ${TSURU_NOW_HOOK_URL} \
    --hook-name pre-receive \
    ${TSURU_NOW_OPTIONS}

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
