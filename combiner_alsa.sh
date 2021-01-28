#! /usr/bin/env bash
###
# Apply adjustments to HomeSeer 'root' image
#
# - Adjust speaker setup to use USB speaker instead of internal one.
#
####
# Platform: Raspian RPi 32bit
####

function Usage()
{
    echo "Usage: $0 [-h] <output path>"
    echo ""
    echo "This script adjusts the HomeSeer for RPi root fs image with"
    echo "new or changed files. This is done to in order to switch the default ALSA output to USB."
}

if [ "$1" == "-h" ]; then
    Usage
    exit;
fi

if [ -z ${1} ]; then
    echo "Usage: $0 [-h] <output path>"
    exit
fi

ROOT_FS=${1}

###
# We need these paths
OUT_IMG=${ROOT_FS}
INP_IMG=${PWD}

###
INP_ALSA=${INP_IMG}/alsa-base_USB.conf

######
# MAIN
######

###
# Sanity

if [ ! -e ${OUT_IMG}/etc/modprobe.d ]; then
    echo "The directory '${OUT_IMG}' seem invalid. Did find root filesystem"
    exit
fi

###
# Add modprobe order of ALSA devices: USB first
if [ ! -f ${OUT_IMG}/etc/modprobe.d/alsa-base.conf ]; then
  echo "Setting ALSA device order: USB first"
  cp ${INP_ALSA} ${OUT_IMG}/etc/modprobe.d/alsa-base.conf
fi

echo "Syncing image..."
sync
sleep 2
echo "Done"


