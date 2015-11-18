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

#Create directory structure
mkdir -p /var/www/html/www/public
touch /var/www/html/www/public/index.html
cat > /var/www/html/www/public/index.html << EOF
<html>
	<head>
		<title>Sorry</title>
	</head>
	<body>
		<h1>Site in construction, coming soon...</h1>
	</body>
</html>
EOF
chown -R apache:apache /var/www/html/www/public
chmod -R 755 /var/www/html

#Setup virtual host
read -p "Enter ServerName: " servername
echo ""
read -p "Enter ServerAlias: " serveralias
echo ""
touch /etc/httpd/sites-available/www.conf
cat > /etc/httpd/sites-available/www.conf << EOF
<VirtualHost *:80>
	ServerName ${servername}
	ServerAlias ${serveralias}
	DocumentRoot /var/www/html/www/public
	ErrorLog logs/www-error_log
	CustomLog logs/www-access_log combined
</VirtualHost>
EOF
ln -s /etc/httpd/sites-available/www.conf /etc/httpd/sites-enabled/www.conf

#Finish
systemctl restart httpd
