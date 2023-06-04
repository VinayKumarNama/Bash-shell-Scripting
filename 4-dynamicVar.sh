#!/bin/bash
Today_Date=$(date +%F)
number_of_sessions=$(who | wc -l)
echo "Good Morning and Today Date is $Today_Date"
echo "Number of Session opened is : $number_of_sessions"