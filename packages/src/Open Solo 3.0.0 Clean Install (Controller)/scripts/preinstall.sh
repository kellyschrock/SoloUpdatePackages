#!/bin/sh

echo "Beginning aircraft recovery partition pre-install script."
echo "Creating update-recovery.log in /log/ directory."
exec > /log/update-recovery.log
exec 2>&1
echo "***********************************"
echo "***********************************"
echo "UPDATE INITIATED $(date)"
echo ""
echo "Current Solo Versions:"
cat /VERSION
cat /STM_VERSION

echo ""
echo "***********************************"
echo "Current Firmware and Home directories:"
ls -lhR /firmware
ls -lhR ~/

echo ""
echo "***********************************"
echo "Creating /tmp/updates/ directory:"
rm -fr ~/*.bin
rm -fr /tmp/updates
mkdir /tmp/updates

echo ""
echo "Pre-Install Prep Complete."
