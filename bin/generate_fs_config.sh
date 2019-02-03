#!/bin/sh
#
# Generate Android filesystem information for SHARP S2 vendor image.
#
if [ $# -lt 1 ]; then
	echo "Usage: $0 VENDOR_DIR"
fi

VENDOR_DIR=$1

#
# Generate wildcard default permissions:
# https://android.googlesource.com/platform/system/core/+/android-9.0.0_r30/libcutils/fs_config.cpp
#
{ \
	find $VENDOR_DIR -type d -printf "vendor/%P 0 2000 0755\n"; \
	find $VENDOR_DIR -not -type d -printf "vendor/%P 0 0 0644\n"; \
} | sed -r "

	# Apply more specific defaults.

	s|^(vendor/build.prop) .*|\1 0 0 0600|
	s|^(vendor/default.prop) .*|\1 0 0 0600|
	s|^(vendor/etc/fs_config_files) .*|\1 0 0 0444|
	s|^(vendor/etc/fs_config_dirs) .*|\1 0 0 0444|
	s|^(vendor/bin/[^ ]+) .*|\1 0 2000 0755|
	s|^(vendor/xbin/[^ ]+) .*|\1 0 2000 0755|

	# Apply vendor-specific permissions and capabilities.

	s|^(vendor/bin/cnd) .*|\1 1000 1000 0755 capabilities=0x1000001400|
	s|^(vendor/bin/hostapd) .*|\1 1010 1010 0755 capabilities=0x3000|
	s|^(vendor/bin/hw/android\.hardware\.bluetooth@1\.0-service-qti) .*|\1 1000 1000 0755 capabilities=0x1000001000|
	s|^(vendor/bin/hw/android\.hardware\.wifi@1\.0-service) .*|\1 1010 1010 0755 capabilities=0x13000|
	s|^(vendor/bin/imsdatadaemon) .*|\1 1000 1000 0755 capabilities=0x400|
	s|^(vendor/bin/ims_rtp_daemon) .*|\1 1000 1001 0755 capabilities=0x400|
	s|^(vendor/bin/pm-service) .*|\1 1000 1000 0755 capabilities=0x400|
	s|^(vendor/bin/slim_daemon) .*|\1 1021 1021 0755 capabilities=0x400|
	s|^(vendor/bin/wcnss_filter) .*|\1 1002 1002 0755 capabilities=0x1000000000|
"
