#!/bin/bash
COMPONENT=mongodb
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
echo -n "Configuring ${COMPONENT} Repo :"
curl -s -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo
Stat $?
echo -n "Installing ${COMPONENT} :"
yum install -y ${COMPONENT}-org &>> $LOGFILE
Stat $?

echo -n "Enabling the DB visibility :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
Stat $? 
echo -n "Starting ${COMPONENT} Service :"
systemctl daemon-reload mongod &>> $LOGFILE
systemctl enable mongod &>> $LOGFILE
systemctl restart mongod &>> $LOGFILE
Stat $?
echo -n "Downloading ${COMPONENT} Schema: "
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
Stat $?
echo -n "Extracting the ${COMPONENT} Schema :"
cd /tmp
unzip ${COMPONENT}.zip &>> $LOGFILE
Stat $?
echo -n "Injecting the ${COMPONENT} Schema :"
cd ${COMPONENT}-main
mongo < catalogue.js
mongo < users.js
Stat $?

echo -e "*********** \e[33m $COMPONENT Installation Completed Successfully \e[0m ***********"
