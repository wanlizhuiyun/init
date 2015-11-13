#!/bin/bash
#Program:
#	This program set up shadowsocks!
#History:
#2015/11/11	Ghost from Beihang University		First release
#2015/11/13	Ghost from Beihang University		Second release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Install shadowsocks
yum -y install python-setuptools supervisor
easy_install pip
pip install shadowsocks

#Prepair json
touch /etc/shadowsocks.json
cat > /etc/shadowsocks.json << EOF
{
    "server":"0.0.0.0",
    "server_port":8989,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"pass",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": true
}
EOF

#Prepair firewall
touch /etc/firewalld/services/shadowsocks.xml
cat > /etc/firewalld/services/shadowsocks.xml << EOF
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>shadowsocks</short>
  <description>enable shadowsocks.</description>
  <port protocol="tcp" port="8989"/>
</service>
EOF
firewall-cmd --reload
firewall-cmd --zone=public --add-service=shadowsocks --permanent
firewall-cmd --reload

#Setup supervisor
cat >> /etc/supervisord.conf << EOF

[program:shadowsocks]
command=ssserver -c /etc/shadowsocks.json
autostart=true
autorestart=true
user=root

EOF
systemctl start supervisord
systemctl enable supervisord

#Optimization
cat >> /etc/sysctl.conf << EOF

# Shadowsocks Optimization
fs.file-max = 51200
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 3240000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_congestion_control = hybla
EOF
cat >> /etc/security/limits.conf << EOF
* soft nofile 51200
* hard nofile 51200
EOF

sysctl -p
