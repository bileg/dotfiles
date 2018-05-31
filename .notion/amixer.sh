#!/bin/bash

#vol=$(amixer get 'Master',0 | egrep -o '[0-9]{1,3}%')
#echo "${vol%[%]}"

param=$(amixer get "$1",0 | grep "$2:" | egrep -o '[0-9]{1,3}%')
echo ${param%[%]}

