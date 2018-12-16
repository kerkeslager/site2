#!/usr/bin/env bash

# $1 is the IP address of the server to provision
# $2 is the username to provision with

ssh -i ~/.ssh/$2 root@$1 "adduser $2 && usermod -aG sudo $2 && usermod -aG staff && apt update && apt install ufw && ufw allow OpenSSH && cp -r ~/.ssh /home/$2 && chown -R $2:$2 /home/$2/.ssh"
ssh $2@$1 'sudo apt install git && git clone https://github.com/kerkeslager/site2.git && ./site2/setup/run-on-server.sh'

