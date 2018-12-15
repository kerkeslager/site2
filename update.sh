#!/usr/bin/env bash

git pull
haunt build
sudo mkdir -p /var/www/kerkeslager.com/html
sudo rsync -rtuc --delete site/ /var/www/kerkeslager.com/html/
