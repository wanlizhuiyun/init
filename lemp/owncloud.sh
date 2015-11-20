#!/bin/bash
#Program:
#This program setup owncloud.
#History:
#2015/11/20     Ghost from Beihang University   First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

nginxpath=/etc/nginx
htmlpath=/usr/share/nginx
read -p "Enter ServerName: " servername
echo ""

#Install php extensions
#yum -y install php-dom php-xmlwriter php-gd

#Install owncloud 
mkdir -p ${htmlpath}/${servername}
wget -O ${htmlpath}/${servername}/owncloud.tar.bz2 https://download.owncloud.org/community/owncloud-8.2.1.tar.bz2
tar -jxv -f ${htmlpath}/${servername}/owncloud.tar.bz2 -C ${htmlpath}/${servername}/
rm ${htmlpath}/${servername}/owncloud.tar.bz2
chown -R nginx:nginx ${htmlpath}/${servername}/owncloud
mkdir -p /usr/share/owncloud_data
chown nginx:nginx -R /usr/share/owncloud_data

#Setup virtual host
touch ${nginxpath}/sites-available/${servername}.conf
cat > ${nginxpath}/sites-available/${servername}.conf << EOF
upstream php-handler {
    server 127.0.0.1:9000;
}

server {
        listen 80;
        server_name ${servername};
        return 301 https://\$server_name\$request_uri;  # redirect all to use ssl
}

server {
        listen 443 ssl;
        server_name ${servername};

        #SSL Certificate you created
        ssl_certificate ${nginxpath}/ssl/nginx.crt; 
        ssl_certificate_key ${nginxpath}/ssl/nginx.key;

        # owncloud path
        root ${htmlpath}/${servername}/owncloud;

        client_max_body_size 10G; # set max upload size
        fastcgi_buffers 64 4K;

        rewrite ^/caldav(.*)$ /remote.php/caldav\$1 redirect;
        rewrite ^/carddav(.*)$ /remote.php/carddav\$1 redirect;
        rewrite ^/webdav(.*)$ /remote.php/webdav\$1 redirect;

        index index.php;
        error_page 403 /core/templates/403.php;
        error_page 404 /core/templates/404.php;

        location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
        }

        location ~ ^/(data|config|\.ht|db_structure\.xml|README) {
                deny all;
        }

        location / {
                # The following 2 rules are only needed with webfinger
                rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
                rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;

                rewrite ^/.well-known/carddav /remote.php/carddav/ redirect;
                rewrite ^/.well-known/caldav /remote.php/caldav/ redirect;

                rewrite ^(/core/doc/[^\/]+/)$ \$1/index.html;

                try_files \$uri \$uri/ index.php;
        }

        location ~ ^(.+?\.php)(/.*)?$ {
                try_files \$1 = 404;

                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME \$document_root\$1;
                fastcgi_param PATH_INFO \$2;
                fastcgi_param HTTPS on;
                fastcgi_pass php-handler;
        }

        # Optional: set long EXPIRES header on static assets
        location ~* ^.+\.(jpg|jpeg|gif|bmp|ico|png|css|js|swf)$ {
                expires 30d;
                # Optional: Don't log access to assets
                access_log off;
        }

}
EOF
ln -s ${nginxpath}/sites-available/${servername}.conf ${nginxpath}/sites-enabled/${servername}.conf

#Finish
systemctl restart nginx mariadb php-fpm
