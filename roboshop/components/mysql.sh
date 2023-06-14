#!/bin/bash
COMPONENT=mysql
source components/common.sh

echo -n "Configuring ${COMPONENT} repo :"
curl -s -L -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/${COMPONENT}.repo
Stat $?
echo -n "Installing ${COMPONENT} :"
yum install ${COMPONENT}-community-server -y &>> $LOGFILE
echo -n "starting ${COMPONENT} service :"
systemctl enable mysqld &>> $LOGFILE
systemctl start mysqld  &>> $LOGFILE
Stat $?
echo -n "Fetching default root password : "
DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk  '{print $NF}')
Stat $? 

# I want this to be executed only if the default password reset was not done. 
echo "show databases;" | mysql -uroot -pRoboShop@1 &>> $LOGFILE
if [ $? -ne 0 ] ; then 
    echo -n "Performing password reset of root user:"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p${DEFAULT_ROOT_PASSWORD}   &>> $LOGFILE
    Stat $?
fi 