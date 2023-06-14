#!/bin/bash 

COMPONENT="rabbitmq"

source components/common.sh

echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"

echo -n "Configuring the $COMPONENT repo: "
curl -s https://packagecloud.io/install/repositories/${COMPONENT}/erlang/script.rpm.sh | sudo bash   &>> $LOGFILE
curl -s https://packagecloud.io/install/repositories/${COMPONENT}/${COMPONENT}-server/script.rpm.sh | sudo bash     &>> $LOGFILE
stat $? 

echo -n "Installing $COMPONENT: "
yum install ${COMPONENT}-server -y      &>> $LOGFILE 
stat $? 

echo -n "Starting $COMPONENT :"
systemctl enable ${COMPONENT}-server    &>> $LOGFILE
systemctl restart ${COMPONENT}-server   &>> $LOGFILE
stat $?

# This needs to run only if the user account doesn't exist 
rabbitmqctl list_users | grep roboshop  &>> $LOGFILE 
if [ $? -ne 0 ] ; then 
    echo -n "Creating the $COMPONENT $APPUser :"
    rabbitmqctl add_user roboshop roboshop123    &>> $LOGFILE
    stat $?
fi 

echo -n "Configuring the $COMPONENT $APPUser privileges:"
rabbitmqctl set_user_tags roboshop administrator     &>> $LOGFILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"     &>> $LOGFILE
stat $? 

echo -e "*********** \e[35m $COMPONENT Installation has completed \e[0m ***********"