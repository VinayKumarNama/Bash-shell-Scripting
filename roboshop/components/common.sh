#! /bin/bash
APPUser=roboshop
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
CREATEUSER()
{
    id ${APPUser} &>> $LOGFILE
    if [ $? -ne 0 ]; then
    echo -n "Creating the service Account :"
    useradd ${APPUser}  &>> $LOGFILE
    Stat $?
    fi
}
DOWNLOAD_AND_EXTRACT()
{
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
    chown -R $APPUser:$APPUser /home/${APPUser}/$COMPONENT/ &>> $LOGFILE
    Stat $?
}
NPM_INSTALL()
{
    echo -n "Generating npm $COMPONENT artifacts :"
    cd /home/${APPUser}/$COMPONENT/ &>> $LOGFILE
    npm install &>> $LOGFILE
    Stat $?
}
CONFIGURE_SVC()
{
    echo -n "Updating the $COMPONENT systemd file :"
    sed -i -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/${APPUser}/${COMPONENT}/systemd.service  
    mv /home/${APPUser}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
    Stat $? 
    echo -n "start the ${COMPONENT} Service :"
    systemctl daemon-reload  &>> $LOGFILE
    systemctl enable ${COMPONENT} &>> $LOGFILE
    systemctl start ${COMPONENT}  &>> $LOGFILE
    Stat $?
    echo -e "*********** \e[33m $COMPONENT Installation Completed Successfully \e[0m ***********"
}
NODEJS()
{
    echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"
    echo -n "Configuring ${COMPONENT} Repo :"
    curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash - &>> $LOGFILE
    Stat $?
    echo -n "Installaing Node Js :"
    yum install nodejs -y &>> $LOGFILE
    Stat $?
    CREATEUSER
    DOWNLOAD_AND_EXTRACT
    NPM_INSTALL
    CONFIGURE_SVC
}
MVN_PACKAGE()
{
    echo -n "Preparing ${COMPONENT} artifacts :"
    cd /home/${APPUser}/${COMPONENT}
    mvn clean package   &>> $LOGFILE
    mv target/shipping-1.0.jar shipping.jar 
    Stat $?
}
JAVA()
{
     echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"
    echo -n "Installaing Maven :"
    yum install maven -y &>> $LOGFILE
    Stat $?
    CREATEUSER
    DOWNLOAD_AND_EXTRACT
    MVN_PACKAGE
    CONFIGURE_SVC 
}
PYTHON()
{
    echo -n "Installing Python and its dependencies :"
    yum install python36 gcc python3-devel -y   &>> $LOGFILE 
    Stat $? 

    CREATE_USER                 # calling Create_user function to create the roboshop user account

    DOWNLOAD_AND_EXTRACT         # calling DOWNLOAD_AND_EXTRACT  function download the content

    echo -n "Installing $COMPONENT"
    cd /home/${APPuser}/${COMPONENT}/
    pip3 install -r requirements.txt    &>> $LOGFILE 
    Stat $?

    USERID=$(id -u roboshop)
    GROUPID=$(id -g roboshop) 

    echo -n "Updating the uid and gid in the $COMPONENT.ini file"
    sed -i -e "/^uid/ c uid=${USERID}" -e "/^gid/ c gid=${GROUPID}"  /home/${APPUser}/${COMPONENT}/${COMPONENT}.ini
    
    CONFIGURE_SVC
}