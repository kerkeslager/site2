#!/usr/bin/env bash

git pull
./generate.sh
sudo mkdir -p /var/www/kerkeslager.com/html
sudo rsync -rtuc --delete site/ /var/www/kerkeslager.com/html/
