#!/bin/bash

## Start of the line in any bash script should always be a SHEBANG NOTATION.

## Apart from the first line, none of the lines are considered as shebang
## Shebang notatin should always start with #!

## Using this SHEBANG Notation, we are telling the system the interpretor to use to run this script.

## Your server would have java, go , python, nodejs, shell installed. ( interpretor )

### Now if you run the script, how system will come to know which interpretor it has to use, that's where SHEBANG Notions helps

#### How to run a linux bash script ? 

    # *   bash scriptName.sh 
    # *   sh scriptName.sh 
    # *   ./scriptName

echo Welcome to Bash Learning

#printing multiple lines
echo Line1
echo line2
echo line3

#in Bash we have escape sequence characters
# \n : New Line
# \t : Tab space

echo -e "Line4\nLine5\tLine6"