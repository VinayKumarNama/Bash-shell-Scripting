#!/bin/bash
Component = frontend
ID=$(id -u)
if [ $ID -ne 0 ] ; then 
    echo -e "\e[31m This script is expected to be run by a root user or with a sudo privilege \e[0m"
    exit 1
fi

echo -n "Installing Nginx : "
yum install nginx -y &>> "/tmp/${Component}.log"

if [ $? -eq 0 ] ; then
    echo -e "\e[32m Success \e[0m"
else
    echo -e "\e[31m Success \e[0m"
fi

echo -n "Downloading ${Component} component :"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
if [ $? -eq 0 ] ; then
    echo -e "\e[32m Success \e[0m"
else
    echo -e "\e[31m Success \e[0m"
fi
 
 echo -n "Performing Cleanup :"
 cd /usr/share/nginx/html
 rm -rf * &>> "/tmp/${Component}.log"
 if [ $? -eq 0 ] ; then
    echo -e "\e[32m Success \e[0m"
else
    echo -e "\e[31m Success \e[0m"
fi

# unzip /tmp/frontend.zip
 #mv frontend-main/* .
 #mv static/* .
 #rm -rf frontend-main README.md
 #mv localhost.conf /etc/nginx/default.d/roboshop.conf
