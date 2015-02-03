#!/bin/bash -eux

echo "mysql" > /etc/hostname ; hostname `cat /etc/hostname`

apt-get install software-properties-common
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
add-apt-repository "deb http://mirror.stshosting.co.uk/mariadb/repo/10.0/ubuntu trusty main"
apt-get update
apt-get install -y mariadb-server

apt-get autoremove -y
