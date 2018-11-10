#!/bin/sh

## Check the files that were uploaded to the /firmware directory.
packageValid() {
    if [ -e /firmware/artoo_copter37.bin ]
    then
        return 0
    else
        return 1
    fi
}


if ! packageValid; then
    echo "Installation package is corrupt, invalid, or missing. Aborting."
    exit 1
else
    sololink_config --update-apply artoo
fi
