#!/bin/bash
#Program:
#	This program updates system.
#History:
#2015/11/13	Ghost from Beihang University		First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Update whole system
yum -y update
