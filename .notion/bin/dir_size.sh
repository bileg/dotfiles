
#for f in *; do if [ -d $f ]; then echo $f; du -ch $f | grep total; fi; done

for f in *; do if [ -d $f ]; then s=`du -ch $f | grep total | sed "s/total//"`; echo "$f $s"; fi; done
