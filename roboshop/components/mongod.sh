#!/bin/bash
COMPONENT=mongodb
source components/common.sh
echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"

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
unzip -o ${COMPONENT}.zip &>> $LOGFILE
Stat $?
echo -n "Injecting the ${COMPONENT} Schema :"
cd ${COMPONENT}-main
mongo < catalogue.js &>> $LOGFILE
mongo < users.js     &>> $LOGFILE
Stat $?

echo -e "*********** \e[33m $COMPONENT Installation Completed Successfully \e[0m ***********"
