# CONTRIBUTION
 * `make_ext4fs`: a Linux copy from https://github.com/rkhat2/android-rom-repacker/releases/tag/android-8-v4
 * _SHA1(`make_ext4fs`)_ = `c47658bd7ca3078b5d4c9251f33c59cd4763b05e`
 * `libnfc-nci-oreo.conf`: a copy from https://forum.xda-developers.com/showpost.php?p=78849983&postcount=1832

## `make_ext4fs`

If you use `make_ex4fs` from the Ubuntu's `android-tools-fsutils` (_**5.1.1.r38-1.1**_), you will encounter a bug when making an image that both the **file_contexts** and **capabilities** options are involved:

> `make_ext4fs -s -l 1073741824 -L vendor -a /vendor -C fs_config -S file_contexts vendor_c6d9a78.sparseimg vendor`
> **error: xattr_assert_sane: BUG: extended attributes are not sorted**

It's a known bug and had been fixed in the upstream and thus the [copy](https://github.com/rkhat2/android-rom-repacker/releases/tag/android-8-v4) from the https://github.com/rkhat2/android-rom-repacker/ works without problems. Thanks to **rkha2**.

## `libnfc-nci-oreo.conf`

**HAS BEEN INTEGRATED INTO `/vendor/workaround/`**

With phh's AOSP 9.0,

 * the NFC service would keep crash,
 * and if you switch on/off it in the preferences setting, it gets hang.

Lovetz from XDA [mentioned that](https://forum.xda-developers.com/showpost.php?p=78849983&postcount=1832) there is a configuration need to be overwritten in `/system` in order to make NFC work.
Since it involves the `/system`, I considered as a workaround patch.

### HOW TO PATCH MANUALLY

#### AFTER Flash `/system`, If You Can `su` in `adb shell`

    $ adb push libnfc-nci-oreo.conf /mnt/sdcard/libnfc-nci-oreo.conf
    $ adb shell
    SS2> su
    SS2> mount -o remount,rw /
    SS2> mv /mnt/sdcard/libnfc-nci-oreo.conf /system/phh
    SS2> chown root:root /system/phh/libnfc-nci-oreo.conf
    SS2> chmod 644 /system/phh/libnfc-nci-oreo.conf
    SS2> restorecon /system/phh/libnfc-nci-oreo.conf

#### OR before flashing `/system`

	$ simg2img system-arm64-ab-gapps-su.img phh.img
	$ mkdir phh
	$ sudo mount -t ext4 -o rw,remount phh.img phh
	$ sudo cp libnfc-nci-oreo.conf phh/system/phh
	$ sudo umount phh
	$ fastboot flash system_SLOT phh.img
