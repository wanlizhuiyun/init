#!/bin/bash
#Program:
#	This program initializes a fresh server.
#History:
#2015/11/13	Ghost from Beihang University		First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo '***************************************'
echo '*                                     *'
echo '*   Fresh Server Initialization!      *'
echo '*                                     *'
echo '***************************************'

echo 'Setting up repositories'
sudo sh repositories.sh
echo 'Updating system'
sudo sh updates.sh
echo 'Setting up commly used tools'
sudo sh tools.sh
echo 'Configuring vim'
sh vim.sh

