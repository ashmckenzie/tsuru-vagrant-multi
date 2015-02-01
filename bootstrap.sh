#!/bin/bash -eux

echo "==> Installing tsuru command line tools"
brew tap tsuru/homebrew-tsuru
brew update
brew install tsuru tsuru-admin crane

echo "==> Bring up Vagrant VM's"
vagrant up

echo "===> Adding default target"
tsuru target-add -s default http://192.168.50.4:8080

echo "===> Logging in as admin@example.com (password is admin123)"
tsuru login admin@example.com

echo "===> Add default SSH public key"
tsuru key-add default ~/.ssh/ashmckenzie_2048_rsa.pub

echo "==> tsuru is now ready!"
echo "==> Run ./install_platforms.sh to install Ruby, NodeJS and golang platforms."
