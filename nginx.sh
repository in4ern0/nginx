#!/bin/bash
nginx=stable # use nginx=development for latest development version
echo -ne '\n' | add-apt-repository ppa:nginx/$nginx   #need_check_repos
apt-get update -y
echo -ne '\n' | apt-get install nginx -y
