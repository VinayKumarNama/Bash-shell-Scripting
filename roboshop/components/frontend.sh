#!/bin/bash
COMPONENT=frontend
source components/common.sh
echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"
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
echo -n "Updating the Backend component reverseproxy details :"
for component in catalogue user cart shipping payment; do
sed -i -e "/$component/s/localhost/$component.roboshop.internal/"  /etc/nginx/default.d/roboshop.conf
done
Stat $?
echo -n "Starting $COMPONENT Service :"
systemctl daemon-reload &>> $LOGFILE
systemctl start nginx &>> $LOGFILE
systemctl enable nginx &>> $LOGFILE
Stat $?
echo -e "*********** \e[33m $COMPONENT Installation Completed Successfully \e[0m ***********"