#!/usr/bin/env bash

sudo update-alternatives --config editor

sudo apt install nginx
sudo ufw allow 'Nginx Full'

sudo mkdir -p /var/www/kerkeslager.com/html
sudo chown -R $USER:$USER /var/www/kerkeslager.com/html
sudo cp ~/site2/site/index.html /var/www/example.com/html/

sudo cp ~/site2/nginx_configuration /etc/nginx/sites-available/kerkeslager.com
sudo ln -s /etc/nginx/sites-available/kerkeslager.com /etc/nginx/sites-enabled/

sudo systemctl reload nginx
