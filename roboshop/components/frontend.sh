#!/bin/bash
Component = ${Component}
LogFile = "/tmp/${Component}.log"
ID=$(id -u)
if [ $ID -ne 0 ] ; then 
    echo -e "\e[31m This script is expected to be run by a root user or with a sudo privilege \e[0m"
    exit 1
fi
Stat()
{
if [ $1 -eq 0 ] ; then
    echo -e "\e[32m Success \e[0m"
else
    echo -e "\e[31m Success \e[0m"
    exit 2
fi
}
echo -n "Installing Nginx : "
yum install nginx -y &>> $LogFile
Stat $?
echo -n "Downloading ${Component} component :"
curl -s -L -o /tmp/${Component}.zip "https://github.com/stans-robot-project/${Component}/archive/main.zip"
Stat $? 
echo -n "Performing Cleanup :"
cd /usr/share/nginx/html
rm -rf * &>> "/tmp/${Component}.log"
Stat $?
echo -n "Extracting content :"
unzip /tmp/${Component}.zip &>> $LogFile
mv ${Component}-main/* . &>> $LogFile
mv static/* . &>> $LogFile
rm -rf ${Component}-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
Stat $?
