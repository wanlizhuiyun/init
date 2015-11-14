#!/bin/bash
#Program:
#	This program initializes a fresh server.
#History:
#2015/11/13	Ghost from Beihang University		First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo '***************************************'
echo '*                                     *'
echo '*   Fresh Server Initialization!      *'
echo '*                                     *'
echo '***************************************'

#Add repositories
sudo yum -y install yum-plugin-priorities epel-release http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm

#Configure repositories' priority
sudo sed -i -e "s/\]$/\]\npriority=1/g" /etc/yum.repos.d/CentOS-Base.repo
sudo sed -i -e "s/\]$/\]\npriority=5/g" /etc/yum.repos.d/epel.repo
sudo sed -i -e "s/\]$/\]\npriority=10/g" /etc/yum.repos.d/rpmforge.repo

#Update whole system
sudo yum -y update

#Install tools
sudo yum -y install wget unzip bzip2 vim

#Create vim link
ln -s ~/init/.vim/vimrc ~/.vimrc
