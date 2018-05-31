#!/bin/bash

nmcli con | tr -s ' ' | ( while IFS=" " read -r col1 col2 col3 col4 remainder; do
    #echo "$col1 $col2 $col3 $col4 ---> $remainder";
    if [ "$col3" != "TYPE" ] && [ "$col4" != "--" ]; then
	#echo "$col1"
        #echo ${col4}
	if [ -z "${NET}" ]; then
	    NET=$col1
	else
	    NET="${NET},${col1}"
	fi
    fi
    #echo "${NET}"
done 

echo "${NET}"

)


