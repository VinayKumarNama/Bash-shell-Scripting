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
yum install -y mongodb-org &>> $LOGFILE
Stat $?

