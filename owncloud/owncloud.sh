#!/bin/bash
#Program:
#This program setup owncloud.
#History:
#2015/11/13     Ghost from Beihang University   First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Install php extensions
yum -y install php-dom php-xmlwriter php-gd

#Install owncloud 8.2
mkdir /var/www/html/cloud
wget -O /var/www/html/cloud/owncloud.tar.bz2 https://download.owncloud.org/community/owncloud-8.2.0.tar.bz2
tar -jxv -f /var/www/html/cloud/owncloud.tar.bz2
rm /var/www/html/cloud/owncloud.tar.bz2
chown -R apache:apache /var/www/html/cloud/owncloud

#Setup virtual host
touch /etc/httpd/sites-available/cloud.conf
cat > /etc/httpd/sites-available/cloud.conf << EOF
<VirtualHost *:80>
	ServerName cloud
	<IfModule mod_alias.c>
		Alias /owncloud /var/www/html/cloud/owncloud
	</IfModule>
	DocumentRoot /var/www/html/cloud/owncloud
	<Directory "/var/www/html/cloud/owncloud">
		Options Indexes FollowSymLinks
		AllowOverride All
		Order allow,deny
		allow from all
	</Directory>
	ErrorLog logs/cloud-error_log
	CustomLog logs/cloud-access_log combined
</VirtualHost>
EOF
ln -s /etc/httpd/sites-available/cloud.conf /etc/httpd/sites-enabled/cloud.conf

#Finish
systemctl restart httpd
