#!/bin/bash
COMPONENT=frontend
echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"

ID=$(id -u)
if [ $ID -ne 0 ] ; then 
    echo -e "\e[31m This script is expected to be run by a root user or with a sudo privilege \e[0m"
    exit 1
fi
LOGFILE="/tmp/${COMPONENT}.log"
Stat()
{
if [ $1 -eq 0 ] ; then
    echo -e "\e[32m Success \e[0m"
else
    echo -e "\e[31m Failure \e[0m"
    exit 2
fi
}
echo -n "Installing Nginx : "
yum install nginx -y   &>> $LOGFILE
Stat $?
echo -n "Downloading $COMPONENT COMPONENT :"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
Stat $? 
echo -n "Performing Cleanup :"
cd /usr/share/nginx/html
rm -rf * &>> "/tmp/${COMPONENT}.log"
Stat $?
echo -n "Extracting content :"
unzip /tmp/${COMPONENT}.zip   &>> $LOGFILE
mv ${COMPONENT}-main/* .
mv static/* .
rm -rf ${COMPONENT}-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
Stat $?
echo -n "Starting $COMPONENT Service :"
systemctl start nginx
systemctl enable nginx
Stat $?