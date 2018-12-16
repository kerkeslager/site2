#!/usr/bin/env bash

git pull
GUILE_LOAD_PATH=/usr/local/share/guile/site/2.0 haunt build
sudo mkdir -p /var/www/kerkeslager.com/html
sudo rsync -rtuc --delete site/ /var/www/kerkeslager.com/html/
