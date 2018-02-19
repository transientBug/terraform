#!/bin/bash -ex
set -euo pipefail

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo BEGIN

echo "Setting up ansible things"

# Install basic stuff for ansible
apt-get update
apt-get -y install python-simplejson python-pip libpq-dev
pip install --upgrade pip
pip install psycopg2

echo "Setting up disk mount"

# Setup the DO Volume, formatting it if it is unformatted
# and then mounting it
DISK=/dev/disk/by-id/scsi-0DO_Volume_${name}
MOUNT=/mnt/${name}

DEVICE_FS=`blkid -o value -s TYPE $DISK`
echo "Disk is formatted? $DEVICE_FS"
if [ "`echo -n $DEVICE_FS`" == "" ] ; then
  echo "Formatting $DISK"
  mkfs.ext4 -F $DISK
fi

echo "Making mount $MOUINT"
mkdir -p $MOUNT

echo "Mounting $DISK"
mount -o discard,defaults $DISK $MOUNT
echo $DISK $MOUNT ext4 defaults,nofail,discard 0 0 | tee -a /etc/fstab

echo END
