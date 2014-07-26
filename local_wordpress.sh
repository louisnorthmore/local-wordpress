#!/bin/bash

clear
echo "... Local WordPress Instance starting..."

cd ~/

rm -rf local_wordpress

mkdir local_wordpress
cd local_wordpress

echo "... Getting (fresh) Vagrant box"
git clone https://github.com/louisnorthmore/vagrant-debian-web.git vagrant

echo "... Starting Vagrant instance"
cd vagrant
vagrant up
ssh-add

echo "... Downloading wp-cli"
vagrant ssh -c 'curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod a+x wp-cli.phar && sudo mv wp-cli.phar /usr/local/bin/wp'

echo "... Downloading WordPress"
vagrant ssh -c 'cd /var/www && wp core download'

echo "... Creating local WordPress config & db"
vagrant ssh -c 'sudo mysql -u root -proot -e "drop schema wordpress"'
vagrant ssh -c 'sudo mysql -u root -proot -e "create schema wordpress"'
vagrant ssh -c 'cd /var/www && wp core config --dbname=wordpress --dbuser=root --dbpass=root'

echo "... Installing WordPress"
vagrant ssh -c 'cd /var/www && wp core install --url=http://wordpress.local --title=wordpress --admin_user=wordpress --admin_password=wordpress --admin_email=wordpress@wordpress.local'

echo "... Adding IP to hosts & wordpress.local"
sudo echo "10.20.30.40 wordpress.local" | sudo tee -a /etc/hosts

echo "Launching browser"
open "http://wordpress.local/"

echo "Done! :-)"
