#!/bin/bash
#Program:
#	This program manages repositories.
#History:
#2015/10/29	Ghost from Beihang University		First release
#2015/11/04	Ghost from Beihang University		Second release
#2015/11/13	Ghost from Beihang University		Third release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Add repositories
yum -y install yum-plugin-priorities epel-release http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
#Configure repositories' priority
sed -i -e "s/\]$/\]\npriority=1/g" /etc/yum.repos.d/CentOS-Base.repo
sed -i -e "s/\]$/\]\npriority=5/g" /etc/yum.repos.d/epel.repo
sed -i -e "s/\]$/\]\npriority=10/g" /etc/yum.repos.d/rpmforge.repo
