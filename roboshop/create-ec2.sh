#! /bin/bash
# AMI_ID="ami-0c1d144c8fdd8d690"

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=b54-allow-all | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')
COMPONENT=$1
ENV=$2
if [ -z "$1" ] || [ -z "$2" ] ; then
    echo -e "\e[31m COMPONENT NAME IS NEEDED \e[0m"
    echo -e "\e[35m Ex Usage : \n \t \t bash create-ec2 componentName envName \e[0m "
    exit 1
fi 
    echo -e "AMI ID used to launch the EC2 is \e[35m $AMI_ID \e[0m"
    echo -e "Security Group ID used to launch the EC2 is \e[35m $SG_ID \e[0m"
    echo -e "\e[36m **** Launching Server **** \e[0m"
IPADDRESS=$(aws ec2 run-instances  --image-id ${AMI_ID}  --instance-type t2.micro   --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT-$ENV}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
echo -e "Private IP Address of $COMPONENT-$ENV is \e[35m $IPADDRESS \e[0m"