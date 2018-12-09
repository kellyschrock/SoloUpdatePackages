#!/bin/sh

## Check the files that were uploaded to the /firmware directory.
packageValid() {
    if [ -e /firmware/artoo-AC37.bin.bin ]
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
