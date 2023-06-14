#!/bin/bash
COMPONENT=mysql
source components/common.sh

echo -n "Configuring ${COMPONENT} repo :"
curl -s -L -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/${COMPONENT}.repo
Stat $?
echo -n "Installing ${COMPONENT} :"
yum install ${COMPONENT}-community-server -y &>> $LOGFILE
echo -n "starting ${COMPONENT} service :"
systemctl enable mysqld 
systemctl start mysqld
Stat $?