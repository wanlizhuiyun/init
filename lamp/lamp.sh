#!/bin/bash
#Program:
#This program setup LAMP infrastructure.
#History:
#2015/11/13	Ghost from Beihang University	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Install lamp
yum -y install httpd mariadb-server mariadb php php-mysql mod_ssl

#Configure lamp
setsebool -P httpd_unified 1
#firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
systemctl start httpd
systemctl start mariadb
systemctl enable httpd
systemctl enable mariadb
mysql_secure_installation

#ssl
mkdir /etc/httpd/ssl
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/httpd/ssl/apache.key -out /etc/httpd/ssl/apache.crt
#must configure /etc/httpd/conf.d/ssl.conf

#Setup virtual host directory structure
mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled
cat >> /etc/httpd/conf/httpd.conf << EOF
IncludeOptional sites-enabled/*.conf
EOF

#Finish
systemctl restart httpd
