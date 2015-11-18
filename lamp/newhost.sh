#!/bin/bash
#Program:
#This program setup LAMP infrastructure.
#History:
#2015/11/13	Ghost from Beihang University	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Enter ServerName: " servername
echo ""
read -p "Enter ServerAlias: " serveralias
echo ""

#Create web directory structure
mkdir -p /var/www/${servername}/public_html
touch /var/www/${servername}/public_html/index.html
cat > /var/www/${servername}/public_html/index.html << EOF
<html>
	<head>
		<title>Sorry</title>
	</head>
	<body>
		<h1>Site in construction, coming soon...</h1>
	</body>
</html>
EOF
chown -R apache:apache /var/www/${servername}/public_html
chmod -R 755 /var/www

#Setup virtual host
touch /etc/httpd/sites-available/${servername}.conf
cat > /etc/httpd/sites-available/${servername}.conf << EOF
<VirtualHost *:433>
	ServerName ${servername}:433
	ServerAlias ${serveralias}:433
	DocumentRoot /var/www/${servername}/public_html
	SSLCertificateFile /etc/httpd/ssl/apache.crt
	SSLCertificateKeyFile /etc/httpd/ssl/apache.key
	ErrorLog logs/${servername}-error_log
	CustomLog logs/${servername}-access_log combined
</VirtualHost>
EOF
ln -s /etc/httpd/sites-available/${servername}.conf /etc/httpd/sites-enabled/${servername}.conf

#Finish
systemctl restart httpd
