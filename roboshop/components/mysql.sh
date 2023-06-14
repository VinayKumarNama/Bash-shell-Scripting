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
echo "show databases;" | ${COMPONENT} -uroot -pRoboShop@1 &>> $LOGFILE
if [ $? -ne 0 ] ; then 
    echo -n "Performing password reset of root user:"
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | ${COMPONENT} --connect-expired-password -uroot -p${DEFAULT_ROOT_PASSWORD}   &>> $LOGFILE
    Stat $?
fi 
echo "show plugins;" | ${COMPONENT} -uroot -pRoboShop@1 | grep validate_password &>> $LOGFILE
if [ $? -eq 0 ] ; then 
    echo -n "Uninstalling the validate_password plugin :"
    echo "UNINSTALL PLUGIN validate_password;" | ${COMPONENT} -uroot -pRoboShop@1   &>> $LOGFILE
    Stat $?
fi 
echo -n "Downloading the ${COMPONENT} schema :"
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip"
Stat $?
echo -n "Extracting the ${COMPONENT} schema :"
cd /tmp
unzip -o ${COMPONENT}.zip &>> $LOGFILE
cd ${COMPONENT}-main
${COMPONENT} -u root -pRoboShop@1 <shipping.sql &>> $LOGFILE
Stat $? 