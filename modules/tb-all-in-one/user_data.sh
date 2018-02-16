#!/bin/bash
set -euo pipefail

# Install basic stuff for ansible
apt-get update
apt-get -y install python-simplejson python-pip libpq-dev
pip install psycopg2

# Setup the DO Volume, formatting it if it is unformatted
# and then mounting it
DISK=/dev/disk/by-id/scsi-0DO_Volume_${name}
MOUNT=/mnt/${name}

DEVICE_FS=`blkid -o value -s TYPE $DISK`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then
  mkfs.ext4 -F $DISK
fi

mkdir -p $MOUNT
mount -o discard,defaults $DISK $MOUNT
echo $DISK $MOUNT ext4 defaults,nofail,discard 0 0 | tee -a /etc/fstab
