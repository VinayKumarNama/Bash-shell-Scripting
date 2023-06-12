#!/bin/bash

Id=$(id -u)
if [Id -ne 0] ; then
    echo -m "\e[31m This script is expected to be run as root user or sudo privilege \e[0m"
    exit 1
fi

echo "Installing Nginx : "
yum install nginx -y

# yum install nginx -y
# systemctl enable nginx
# systemctl start nginx