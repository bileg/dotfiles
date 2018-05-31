

# sudo fdisk -l       # file system
# pacman -S ntfs-3g
#######sudo mount -t ntfs-3g -o uid=1000,gid=1000 /dev/sdc1 /mnt/usbstick
#https://bbs.archlinux.org/viewtopic.php?id=86264

# mount hiichiheed mount commandaar buh info harj bolno!!!!!

#In order to mount the device you need to know the path to the device node, there are at least two ways of finding out:

#    if the partition you want to mount has a label search in /dev/disk/by-label, if not look in /dev/disk/by-id/ for devices starting with usb, the usable partitions will end with -part#
#    running fdisk -l as root lists all available partition tables
#    search in the output of dmesg for the kernel device name, you can use grep to help you find what you are looking for: dmesg | grep -e "sd[a-z]" 

sudo mount -o rw /dev/sdb1 /mnt/usbstick

#sudo mount -o rw,noauto,async,user,umask=1000 /dev/sdb1 /mnt/usbstick
#sudo mount -o gid=users,fmask=113,dmask=002 /dev/sdc1 /mnt/usbstick

# fat32
#sudo mount -t vfat /dev/sdb1 /mnt/usbstick

# mp3player mount
#sudo mount /dev/sdc1 /mnt/usbstick


