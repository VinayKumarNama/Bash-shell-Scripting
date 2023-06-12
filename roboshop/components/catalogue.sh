#!/bin/bash
COMPONENT=catalogue
APPUser=roboshop
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
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
Stat $?
echo -n "Installaing Node Js :"
yum install nodejs -y &>> $LOGFILE
Stat $?
id ${APPUser} &>> $LOGFILE
if [ $? -ne 0 ]; then
echo -n "Creating the service Account :"
useradd ${APPUser}
Stat $?
fi