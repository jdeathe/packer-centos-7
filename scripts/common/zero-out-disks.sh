#!/bin/bash -e

SWAP_DEVICE=$(
  /bin/readlink -f /dev/disk/by-uuid/$(
    /sbin/blkid -l -o value -s UUID -t TYPE=swap
  )
)

/bin/echo '--> Zero out and reset swap.'
if [[ ${SWAP_DEVICE} == /dev/disk/by-uuid ]]; then
  /bin/echo '---> Skipping (No swap device).'
else
  /sbin/swapoff -a
  /bin/dd if=/dev/zero of=${SWAP_DEVICE} bs=1M
  /sbin/mkswap -f ${SWAP_DEVICE}
fi

/bin/echo '--> Zero out any remaining free disk space.'
/bin/dd if=/dev/zero of=/boot/boot.zero bs=1M

# Old QEMU versions fail if dd writes out too much data in one file.
OF_ID=1
OF_SIZE=4096
while dd if=/dev/zero of=/${OF_ID}.zero bs=1M count=${OF_SIZE}; do 
  (( OF_ID++ )); 
done

/bin/find /{,boot} -name *.zero -delete
