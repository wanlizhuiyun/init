#!/bin/bash
#Program:
#This program setup owncloud.
#History:
#2015/11/20     Ghost from Beihang University   First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Install php extensions
#yum -y install php-dom php-xmlwriter php-gd
nginxpath=/etc/nginx
htmlpath=/usr/share/nginx


#Install owncloud 
mkdir /var/www/html/cloud
wget -O /var/www/html/cloud/owncloud.tar.bz2 https://download.owncloud.org/community/owncloud-8.2.0.tar.bz2
tar -jxv -f /var/www/html/cloud/owncloud.tar.bz2 -C /var/www/html/cloud/
rm /var/www/html/cloud/owncloud.tar.bz2
chown -R apache:apache /var/www/html/cloud/owncloud

#Setup virtual host
read -p "Enter ServerName: " servername
echo ""
touch /etc/httpd/sites-available/cloud.conf
cat > /etc/httpd/sites-available/cloud.conf << EOF
<VirtualHost *:80>
	ServerName ${servername}
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

#Setup data directory
mkdir /var/owncloud_data

ocpath='/var/www/html/cloud/owncloud'
htuser='apache'
htgroup='apache'
rootuser='root'

find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750

chown -R ${rootuser}:${htgroup} ${ocpath}/
chown -R ${htuser}:${htgroup} ${ocpath}/apps/
chown -R ${htuser}:${htgroup} ${ocpath}/config/
chown -R ${htuser}:${htgroup} /var/owncloud_data/
chown -R ${htuser}:${htgroup} ${ocpath}/themes/

chown ${rootuser}:${htgroup} ${ocpath}/.htaccess
chown ${rootuser}:${htgroup} ${ocpath}/data/.htaccess

chmod 0644 ${ocpath}/.htaccess
chmod 0644 /var/owncloud_data/.htaccess
