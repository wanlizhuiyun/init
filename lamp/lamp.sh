#!/bin/bash
#Program:
#This program setup LAMP infrastructure.
#History:
#2015/11/13	Ghost from Beihang University	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Install lamp
yum -y install httpd mariadb-server mariadb php php-mysql

#Configure lamp
setsebool -P httpd_unified 1
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
systemctl start httpd
systemctl start mariadb
systemctl enable httpd
systemctl enable mariadb
mysql_secure_installation
