#!/bin/bash
#Program:
#	This program initializes a fresh server.
#History:
#2015/11/13	Ghost from Beihang University		First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo '***********************************************'
echo '*                                             *'
echo '*        Fresh Server Initialization!         *'
echo '*                                             *'
echo '***********************************************'

#Enable firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld

#Set timezone
sudo timedatectl set-timezone Asia/Shanghai

#Set swap
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cat >> /etc/fstab << EOF
/swapfile swap  swap  sw  0 0
EOF
sudo sysctl vm.swappiness=10
sudo sysctl vm.vfs_cache_pressure=50
sudo cat >> /etc/sysctl.conf << EOF
vm.swappiness = 10
vm.vfs_cache_pressure = 50
EOF


#Configure repositories' priority
sudo yum -y install yum-plugin-priorities
sudo sed -i -e "s/\]$/\]\npriority=1/g" /etc/yum.repos.d/CentOS-Base.repo
sudo yum -y install epel-release
sudo sed -i -e "s/\]$/\]\npriority=5/g" /etc/yum.repos.d/epel.repo
sudo yum -y install http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
sudo sed -i -e "s/\]$/\]\npriority=10/g" /etc/yum.repos.d/rpmforge.repo

#Update whole system
sudo yum -y update

#Install tools
sudo yum -y install wget unzip bzip2 vim

#Create vim link
ln -s ~/init/.vim/vimrc ~/.vimrc
