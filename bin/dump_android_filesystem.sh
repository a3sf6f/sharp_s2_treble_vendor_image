#!/bin/sh
#
# Dump file informations in fs_config format to insepct repacked images more easily.
#
# fs_config format:
# https://android.googlesource.com/platform/build/+/android-9.0.0_r30/tools/fs_config/fs_config.c
#

if [ $# -le 0 ]; then
	echo "Usage: sudo $0 MOUNTED_VENDOR_DIR"
	exit
fi

getcap=$(dirname $(readlink -f $0))/getcap_helper.pl

find $1 -printf "%P %U %G %#m selabel=%Z capabilities=" -exec $getcap {} \; | LC_ALL=C sort -s
