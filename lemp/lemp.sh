#!/bin/bash
#Program:
#This program setup LEMP infrastructure.
#History:
#2015/11/19	Ghost from Beihang University	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Install lamp
yum -y install nginx mariadb-server mariadb php php-mysql php-fpm
nginxpath=/etc/nginx
docpath=/usr/share/nginx

#Configure lamp
setsebool -P httpd_unified 1
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
systemctl start nginx
systemctl start mariadb
systemctl enable nginx
systemctl enable mariadb
mysql_secure_installation

#ssl
mkdir ${nginxpath}/ssl
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ${nginxpath}/ssl/nginx.key -out ${nginxpath}/ssl/nginx.crt
#must configure ${nginxpath}/conf.d/ssl.conf

#Setup virtual host directory structure
#mkdir ${nginxpath}/sites-available
#mkdir ${nginxpath}/sites-enabled
#cat >> ${nginxpath}/conf/httpd.conf << EOF
#IncludeOptional sites-enabled/*.conf
#EOF

#Finish
chmod -R 755 ${docpath}
systemctl restart nginx
