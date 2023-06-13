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
useradd ${APPUser}  &>> $LOGFILE
Stat $?
fi
echo -n "Downloading $COMPONENT componet :"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
Stat $?
echo -n "Copying the $COMPONENT to ${APPUser} home directory "
cd /home/${APPUser} &>> $LOGFILE
rm -rf ${COMPONENT} &>> $LOGFILE
unzip -o /tmp/${COMPONENT}.zip &>> $LOGFILE
Stat $?
echo -n "Modifying the ownership :"
    mv $COMPONENT-main/ $COMPONENT 
    chown -R $APPUSER:$APPUSER /home/${APPUser}/$COMPONENT/ &>> $LOGFILE
    Stat $?
echo -n "Generating npm $COMPONENT artifacts :"
    cd /home/${APPUser}/$COMPONENT/ &>> $LOGFILE
    npm install &>> $LOGFILE
    Stat $?
echo -n "Updating the $COMPONENT  Systemd file :"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/${APPUSER}/${COMPONENT}/systemd.service &>> $LOGFILE
mv /home/${APPUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>> $LOGFILE
Stat $?
echo -n "start the ${COMPONENT} Service :"
systemctl daemon-reload &>> $LOGFILE
systemctl enable ${COMPONENT} &>> $LOGFILE
systemctl start ${COMPONENT}  &>> $LOGFILE
Stat $?
echo -e "*********** \e[33m $COMPONENT Installation Completed Successfully \e[0m ***********"