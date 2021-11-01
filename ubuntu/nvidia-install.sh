#!/bin/bash

apt-get install linux-headers-$(uname -r)
apt-get purge nvidia*

echo "++ update grub config"
sed -i.bak-`date +%s` 's/^\(GRUB_CMDLINE_LINUX=\"\)\(.*\)\"/\1\2 nouveau.modeset=0\"/g' /etc/default/grub

# reboot

DRIVER_VERSION=418.197.02
echo "++ downloading nvidia-driver version $DRIVER_VERSION"
if [[ `sudo find /opt/data -maxdepth 2 -iname 'NVIDIA-Linux*' | wc -l` -eq 0 ]]; then 
   BASE_URL=https://us.download.nvidia.com/tesla
   cd /opt/data/ && sudo curl -fSsl -O $BASE_URL/$DRIVER_VERSION/NVIDIA-Linux-x86_64-$DRIVER_VERSION.run
fi
[ -f /opt/data/NVIDIA-Linux-x86_64-$DRIVER_VERSION.run ]] && {
   echo "+++ installing the driver..."
   sh /opt/data/NVIDIA-Linux-x86_64-$DRIVER_VERSION.run -s -a
}
