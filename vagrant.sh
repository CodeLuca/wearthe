apt-get update
apt-get install --yes lamp-server^
rm -rf /var/www/
ln -s /vagrant/ /var/www/
