#!/bin/bash
#Program:
#	This program create link in home directory for .vimrc & set up vim plugins.
#History:
#2015/11/04	Ghost from Beihang University		first release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#Create link
ln -s ~/init/.vim/vimrc ~/.vimrc

#Setup plugins
