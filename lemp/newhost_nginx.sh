#!/bin/bash
#Program:
#This program setup LAMP infrastructure.
#History:
#2015/11/13	Ghost from Beihang University	First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

htmlpath=/usr/share/nginx

read -p "Enter ServerName: " servername
echo ""
read -p "Enter ServerAlias: " serveralias
echo ""

#Create web directory structure
mkdir -p ${htmlpath}/${servername}/public_html
touch ${htmlpath}/${servername}/public_html/index.html
cat > ${htmlpath}/${servername}/public_html/index.html << EOF
<html>
	<head>
		<title>${servername}</title>
	</head>
	<body>
		<h1>${servername} in construction, coming soon...</h1>
	</body>
</html>
EOF
chown -R apache:apache ${htmlpath}/${servername}/public_html
chmod -R 755 ${htmlpath}/${servername}

#Setup virtual host
touch /etc/httpd/sites-available/${servername}.conf
cat > /etc/httpd/sites-available/${servername}.conf << EOF
<VirtualHost *:433>
	ServerName ${servername}
	ServerAlias ${serveralias}
	DocumentRoot /var/www/${servername}/public_html
	ErrorLog logs/${servername}-error_log
	CustomLog logs/${servername}-access_log combined
	LogLevel warn
	SSLEngine on
	SSLProtocol all -SSLv2
	SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5
	SSLCertificateFile /etc/httpd/ssl/apache.crt
	SSLCertificateKeyFile /etc/httpd/ssl/apache.key
	<Files ~ "\.(cgi|shtml|phtml|php3?)$">
		SSLOptions +StdEnvVars
	</Files>
	<Directory "/var/www/cgi-bin">
		SSLOptions +StdEnvVars
	</Directory>
	BrowserMatch "MSIE [2-5]" \
		nokeepalive ssl-unclean-shutdown \
		downgrade-1.0 force-response-1.0
</VirtualHost>
EOF
ln -s /etc/httpd/sites-available/${servername}.conf /etc/httpd/sites-enabled/${servername}.conf

#Finish
systemctl restart httpd
