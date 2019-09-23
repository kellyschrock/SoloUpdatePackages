#!/bin/sh
set -e

echo "Beginning aircraft recovery partition pre-install script."
echo "Creating installer.log in /log/ directory."
exec > /log/installer.log
exec 2>&1
echo "***********************************"
echo "***********************************"
echo "UPDATE INITIATED $(date)"
echo ""
echo "Current Solo Versions:"
cat /VERSION

echo ""
echo "***********************************"
echo "Current Firmware and Home directories:"
ls -lhR /firmware
ls -lhR ~/

echo ""
echo "***********************************"
echo "Creating /tmp/updates/ directory:"
rm -rf ~/*.bin
rm -rf /firmware
mkdir -p /firmware
rm -rf /tmp/updates
mkdir /tmp/updates
rm -rf /log/updates

echo ""
echo "Pre-Install Prep Complete."

