#!/bin/bash
#Program:
#	This script configure owncloud repo and install owncloud.
#History:
#2015/11/12	Ghost from Beihang University		First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Configure repo for owncloud
rpm --import https://download.owncloud.org/download/repositories/stable/CentOS_7/repodata/repomd.xml.key
wget http://download.owncloud.org/download/repositories/stable/CentOS_7/ce:stable.repo -O /etc/yum.repos.d/ce:stable.repo

#Install owncloud
yum -y install httpd mariadb-server mariadb php php-mysql owncloud

#Enable mariadb and httpd
systemctl start httpd
systemctl enable httpd
systemctl start mariadb
systemctl enable mariadb

#Prepare database
mysql_secure_installation
mysql -u root -p
create database owncloud;
create user 'owncloud'@'localhost' identified by 'owncloud';
grant all on owncloud.* to 'owncloud'@'localhost';
flush privileges;
quit

#Prepare firewall
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload


