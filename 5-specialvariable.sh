#!/bin/bash
# Special variables gives special properties 

# Here are few of the special variabes :  $0 to $9 , $? ,  $#,  $* , $@ 

echo $0     # $0 prints the script name yoi're executing 
echo "Name of the script executed is $0"
echo "Name of the User is $1"
echo "Learning Course is $2"
echo "Current Job is $3" 

# We can supply the values from the command line 

# bash scriptName.sh Val1   val2   val3    ( like this you can supply a maximum of 9 variables from the command line)
#                     $1     $2      $3  

echo $*    # $* is going to print the used variables  
echo $@    # $@ is going to print the used variables  
echo $$    # $$ is going to print the PID of the current proces 
echo $#    # $# is going to pring the number of arguments
echo $?    # $? is going to print the exit code of the last command.