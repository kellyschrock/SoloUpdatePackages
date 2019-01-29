#!/bin/sh

if [ -e /firmware/*.px4]
then
    rm /firmware/*.px4
fi

if [ -e /firmware/*.apj]
then
    rm /firmware/*.apj
fi
