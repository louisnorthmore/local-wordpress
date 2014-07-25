#!/bin/bash

clear
echo "... Local WordPress Instance starting..."

cd ~/
mkdir local_wordpress
cd local_wordpress

echo "... cloning WordPress from github"
git clone https://github.com/WordPress/WordPress .

echo "... Getting (fresh) Vagrant box"
git clone git@github.com:louisnorthmore/vagrant-debian-web.git vagrant


echo "... Starting Vagrant instance"
cd vagrant
vagrant up
ssh-add

echo "... Creating local WordPress DB"
vagrant ssh -c 'sudo mysql -u root -proot -e "drop schema wordpress"'
vagrant ssh -c 'sudo mysql -u root -proot -e "create schema wordpress"'

echo "... Adding IP to hosts & wordpress.local"
sudo 'echo "10.20.30.40 wordpress.local" >> /etc/hosts'

echo "Launching browser"
open "http://wordpress.local/"

echo "Done! :-)"
