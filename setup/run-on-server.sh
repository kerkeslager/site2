#!/usr/bin/env bash

pushd ~/site2

sudo update-alternatives --config editor

sudo apt install nginx
sudo ufw allow 'Nginx Full'

sudo mkdir -p /var/www/kerkeslager.com/html
sudo chown -R $USER:$USER /var/www/kerkeslager.com/html

./generate.sh
sudo cp -r site/* /var/www/example.com/html/

sudo cp nginx_configuration /etc/nginx/sites-available/kerkeslager.com
sudo ln -s /etc/nginx/sites-available/kerkeslager.com /etc/nginx/sites-enabled/

echo 'deb http://deb.debian.org/debian stretch-backports main contrib non-free' | sudo tee -a /etc/apt/sources.list
echo 'deb-src http://deb.debian.org/debian stretch-backports main contrib non-free' | sudo tee -a /etc/apt/sources.list

sudo apt update
sudo apt install python-certbot-nginx -t stretch-backports

sudo systemctl reload nginx

sudo certbot --nginx -d kerkeslager.com -d www.kerkeslager.com

sudo systemctl reload nginx

popd
