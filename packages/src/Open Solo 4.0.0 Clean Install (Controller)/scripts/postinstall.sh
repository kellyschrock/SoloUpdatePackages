#!/bin/sh

## Check the files that were uploaded to the /tmp/updates/ directory.
packageValid() {
    set -e
    cd /tmp/updates/
    if ! md5sum -c ./*.md5; then
        echo "Error checking md5sum"
        return 1
    fi
}

prepController(){
    set -e
    # locally configure the copter for install
    sololink_config --update-prepare sololink
    cp /tmp/updates/3dr-controller.tar.* /log/updates
    touch /log/updates/UPDATE
    touch /log/updates/RESETSETTINGS
    echo "/log/updates/ new contents:"
    ls -lhR /log/updates
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

if ! packageValid; then
    echo "Installation package is corrupt, invalid, or missing. Aborting."
    bailOut
fi

if ! prepController; then
    echo "Error preparing controller. Aborting"
    bailOut
fi

echo "Installation succeeded. Reboot solo to execute."

exit 0
