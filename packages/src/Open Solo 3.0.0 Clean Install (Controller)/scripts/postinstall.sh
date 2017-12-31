#!/bin/sh

## Check the files that were uploaded to the /tmp/updates/ directory.
packageValid() {
    cd /tmp/updates
    md5sum -c ./*.md5
}
 
## Check to see if we're currently in reocovery or system boot partition.
## We can't install a recovery update if we're already in recovery.
onSystem() {
    set -e
    boot_dev=$(grep 'boot' /proc/mounts | awk '{print $1}')
    # boot_dev should be either:
    #   /dev/mmcblk0p1 when running golden, or
    #   /dev/mmcblk0p2 when running latest
    if [ ${boot_dev} == "/dev/mmcblk0p2" ]; then
        echo "Device is currently on the system boot partition."
        return 0
    elif [ ${boot_dev} == "/dev/mmcblk0p1" ]; then
        echo "Device is currently on the recovery boot partition"
        return 1
    else
        echo "Can't determine boot partition"
        return 1
    fi
}

installGolden() {
    set -e
    umount /dev/mmcblk0p1 &> /dev/null
    mkfs.vfat /dev/mmcblk0p1 -n GOLDEN &> /dev/null
    mkdir -p /tmp/golden
    mount /dev/mmcblk0p1 /tmp/golden
    tar -xzvf /tmp/updates/*controller.tar.gz -C /tmp/golden
    echo "Recovery partition new contents:"
    ls -lhR /tmp/golden
    umount /tmp/golden
    touch /log/updates/FACTORYRESET
}

echo ""
cd /
echo "Preparing to execute updates..."
echo "Outputting to /log/recovery-update.log"
exec >> /log/update-recovery.log
exec 2>&1
echo ""
echo "***********************************"
echo ""
echo "Temp Updates Directory:"
ls -lhR /tmp/updates/

if ! packageValid; then
    echo "Installation package is corrupt, invalid, or missing. Aborting."
    exit 1
fi


if ! onSystem; then
    echo "Can't install recovery image while on recovery image. Aborting"
    exit 1
fi

if ! installGolden; then
    echo "Installing recovery on Solo failed" | tee /dev/tty
    exit 1
fi

echo "Installation succeeded. Reboot controller to execute."

