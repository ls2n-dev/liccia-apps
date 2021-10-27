#!/bin/bash
#
export DEV=/dev/sdb
export MOUNTPOINT=/opt/data
[ ! -d $MOUNTPOINT ] && sudo mkdir -p $MOUNTPOINT 2>/dev/null
# add in fstab disk mount point
if [[ `dmesg | grep -Ei '[sv]db' | grep 'Attached'` ]]; then
   if [ -z "`grep $DEV /etc/fstab 2>/dev/null`" ]; then
      sudo sh -c "echo '${DEV}1 $MOUNTPOINT ext4 defaults 0 0' >> /etc/fstab"
      sudo mount -a
   fi
fi
