#!/bin/bash
#Program:
#This program setup LEMP infrastructure.
#History:
#2015/11/19	Ghost from Beihang University	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Install lemp
yum -y install nginx mariadb-server mariadb php php-mysql php-fpm
nginxpath=/etc/nginx
htmlpath=/usr/share/nginx

#Configure lemp
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
systemctl start nginx
systemctl start mariadb
systemctl enable nginx
systemctl enable mariadb
mysql_secure_installation

#config php php-fpm
#cp /etc/php.ini /etc/php.ini.bak
#sed -i "s/\;cgi\.fix\_pathinfo\=1/cgi\.fix\_pathinfo\=0/g" /etc/php.ini
cp /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.bak
#sed -i "s/^listen\ \=\ 127\.0\.0\.1\:9000$/listen\ \=\ \/var\/run\/php\-fpm\/php\-fpm\.sock/g" /etc/php-fpm.d/www.conf
sed -i "s/^;listen\.owner\ \=\ nobody$/listen\.owner\ \=\ nobody/g" /etc/php-fpm.d/www.conf
sed -i "s/^;listen\.group\ \=\ nobody$/listen\.group\ \=\ nobody/g" /etc/php-fpm.d/www.conf
sed -i "s/^user\ \=\ apache$/user\ \=\ nginx/g" /etc/php-fpm.d/www.conf
sed -i "s/^group\ \=\ apache$/group\ \=\ nginx/g" /etc/php-fpm.d/www.conf
mkdir -p /var/lib/php/session
chown nginx:nginx -R /var/lib/php/session/
systemctl start php-fpm
systemctl enable php-fpm

#ssl
mkdir ${nginxpath}/ssl
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout ${nginxpath}/ssl/nginx.key -out ${nginxpath}/ssl/nginx.crt
chmod 600 ${nginxpath}/ssl/nginx.key
chmod 600 ${nginxpath}/ssl/nginx.crt

#Setup virtual host directory structure
mkdir ${nginxpath}/sites-available
mkdir ${nginxpath}/sites-enabled
#cp ${nginxpath}/nginx.conf ${nginxpath}/nginx.conf.bak
#cat >> ${nginxpath}/nginx.conf << EOF
#include /etc/nginx/sites-enabled/*.conf;
#EOF

#Virtual Host
#touch ${nginxpath}/

#Finish
chmod -R 755 ${htmlpath}
systemctl restart nginx
