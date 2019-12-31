#!/bin/sh

setPermissions(){
    set -e
    # Set executable permissions
    chmod a+x /usr/bin/pixhawk.py
    chmod a+x /usr/bin/uploader.py
}

## Check the files that were uploaded to the /tmp/updates/ directory.
packageValid() {
    set -e
    cd /tmp/updates
    if ! md5sum -c ./*.md5; then
        echo "Error checking md5sum"
        return 1
    fi
}

prepCopter(){
    set -e
    # locally configure the copter for install
    sololink_config --update-prepare sololink
    cp /tmp/updates/3dr-solo.tar.* /log/updates
    touch /log/updates/UPDATE
    touch /log/updates/RESETSETTINGS
    echo "/log/updates/ new contents:"
    ls -lhR /log/updates
}

installArduCopter() {
    set -e
    cp /tmp/updates/*.apj /firmware 
    echo "/firmware new contents:"
    ls -lhR /firmware
    pixhawk.py --load /firmware/arducopter.apj
    rm -rf /firmware/*.apj
}

bailOut(){
    rm -rf /log/updates
    rm -rf /firmware
    mkdir -p /firmware
    exit 1
}

echo ""
cd /
echo "Preparing to execute updates..."
echo "Outputting to /log/installer.log"
exec >> /log/installer.log
exec 2>&1
echo ""
echo "***********************************"
echo ""
echo "Temp Updates Directory:"
ls -lhR /tmp/updates/

if ! setPermissions; then
    echo "Failed to set permissions. Aborting."
    bailOut
fi

if ! packageValid; then
    echo "Installation package is corrupt, invalid, or missing. Aborting."
    bailOut
fi

if ! prepCopter; then
    echo "Error preparing copter. Aborting"
    bailOut
fi

if ! installArduCopter; then
    echo "Error copying ArduCopter FW. Aborting"
    bailOut
fi

echo "Installation succeeded. Reboot solo to execute."

exit 0
