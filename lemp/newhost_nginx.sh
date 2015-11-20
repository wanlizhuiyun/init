#!/bin/bash
#Program:
#This program setup LAMP infrastructure.
#History:
#2015/11/13     Ghost from Beihang University   First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

nginxpath=/etc/nginx
htmlpath=/usr/share/nginx

read -p "Enter ServerName: " servername
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
chown -R nginx:nginx ${htmlpath}/${servername}/public_html
chmod -R 755 ${htmlpath}/${servername}

#Setup virtual host
touch ${nginxpath}/sites-available/${servername}.conf
cat > ${nginxpath}/sites-available/${servername}.conf << EOF
server {
        listen  443;
        server_name     ${servername};
        root            ${htmlpath}/${servername}/public_html;
        index           index.php index.html index.htm;

#       location / {
#               try_files $uri $uri/ =404;
#       }
#       error_page 404 /404.html
#       error_page 500 502 503 504 /50x.html;
#       location = /50x.html {
#               root    ${htmlpath}/html;
#       }

        location ~ \.php$ {
                try_files \$uri =404;
                fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                include fastcgi_params;
        }

}
EOF
ln -s ${nginxpath}/sites-available/${servername}.conf ${nginxpath}/sites-enabled/${servername}.conf

#Finish
systemctl restart nginx
