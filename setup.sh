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
systemctl start firewalld
systemctl enable firewalld

#Set timezone
timedatectl set-timezone Asia/Shanghai

#Set swap
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
cat >> /etc/fstab << EOF
/swapfile swap  swap  sw  0 0
EOF
sysctl vm.swappiness=10
sysctl vm.vfs_cache_pressure=50
cat >> /etc/sysctl.conf << EOF
vm.swappiness = 10
vm.vfs_cache_pressure = 50
EOF


#Configure repositories' priority
yum -y install yum-plugin-priorities
sed -i "s/\]$/\]\npriority=1/g" /etc/yum.repos.d/CentOS-Base.repo
yum -y install epel-release
sed -i "s/\]$/\]\npriority=5/g" /etc/yum.repos.d/epel.repo
yum -y install http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
sed -i "s/\]$/\]\npriority=10/g" /etc/yum.repos.d/rpmforge.repo

#Update whole system
yum -y update

#Install tools
yum -y install wget unzip bzip2 vim

#Create vim link
cp .vim/vimrc ${PWD%/*}/.vimrc
cp .vim/vimrc /root/.vimrc
