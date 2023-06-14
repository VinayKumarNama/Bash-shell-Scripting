#!/bin/bash
COMPONENT=redis
source components/common.sh
echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"

echo -n "Configuring ${COMPONENT} Repo :"
curl -L https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/${COMPONENT}.repo -o /etc/yum.repos.d/${COMPONENT}.repo &>> $LOGFILE
Stat $?
echo -n "Installing ${COMPONENT} :"
yum install -y ${COMPONENT}-6.2.11 &>> $LOGFILE
Stat $?

echo -n "Enabling the DB visibility :"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/${COMPONENT}.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/${COMPONENT}/${COMPONENT}.conf
Stat $? 
echo -n "Starting ${COMPONENT} Service :"
systemctl daemon-reload ${COMPONENT} &>> $LOGFILE
systemctl enable ${COMPONENT} &>> $LOGFILE
systemctl restart ${COMPONENT} &>> $LOGFILE
Stat $?

echo -e "*********** \e[33m $COMPONENT Installation Completed Successfully \e[0m ***********"
