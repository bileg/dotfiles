
find $1 -type f -size +20000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'

