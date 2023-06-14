#!/bin/bash
COMPONENT=catalogue
source components/common.sh
echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"
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
sed -i -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/${APPUser}/${COMPONENT}/systemd.service  
 mv /home/${APPUser}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
Stat $?
echo -n "start the ${COMPONENT} Service :"
systemctl daemon-reload &>> $LOGFILE
systemctl enable ${COMPONENT} &>> $LOGFILE
systemctl start ${COMPONENT}  &>> $LOGFILE
Stat $?
echo -e "*********** \e[33m $COMPONENT Installation Completed Successfully \e[0m ***********"