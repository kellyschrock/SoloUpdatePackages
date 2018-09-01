#!/bin/sh

set -e

if [ -e /firmware/*.bin ]
then
    rm /firmware/*.bin
fi

