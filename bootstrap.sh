#!/usr/bin/env bash

brew tap tsuru/homebrew-tsuru
brew update
brew install tsuru tsuru-admin crane

#vagrant destroy --force
vagrant up --parallel

echo "==> tsuru is now ready!"
echo "==> Run ./install_platforms.sh to install Ruby, NodeJS and golang platforms."
