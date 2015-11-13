#!/bin/bash
#Program:
#This script setup owncloud.
#History:
#2015/11/13	Ghost from Beihang University 	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Install php extensions
yum -y install php-dom php-xmlwriter php-gd

#Install owncloud
wget -O owncloud https://download.owncloud.org/community/owncloud-8.2.0.tar.bz2
tar -jxv -f owncloud -C 
