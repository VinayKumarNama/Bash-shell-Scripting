#!/bin/bash
#Each and every color will have different values
# Colors       Foreground          Background

# Red               31                  41

# Green             32                  42

# Yellow            33                  43

# Blue              34                  44

# Magenta           35                  45

# Cyan              36                  46
 

 # The syntax to print colors is 
 # Ex:  
 #      echo -e "\e[COL-CODEm  Your Message To Be Printed \e[0m"
 #      echo -e "\e[32m I am printing Green Color \e[0m"
echo -e "\e[32m Welcome to Bash Learning \e[0m"
echo -e "\e[33m Welcome to Bash Learning \e[0m"
echo -e "\e[34m Welcome to Bash Learning \e[0m"
echo -e "\e[35m Welcome to Bash Learning \e[0m"
echo -e "\e[36m Welcome to Bash Learning \e[0m"

#printing Background colors

echo -e "\e[41;32m Welcome to Bash Learning \e[0m"
echo -e "\e[42;33m Welcome to Bash Learning \e[0m"
echo -e "\e[44;34m Welcome to Bash Learning \e[0m"
echo -e "\e[43;35m Welcome to Bash Learning \e[0m"
echo -e "\e[45;36m Welcome to Bash Learning \e[0m"
