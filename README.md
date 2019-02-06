# sharp_s2_treble_vendor_image
The project is to maintain a treble-compatible vendor image for [SHARP AQUOS S2](https://www.gsmarena.com/sharp_aquos_s2-8797.php). Make it fit to the latest Android version as possible. As of writing, the image had been tested under [phhusson's AOSP 9.0 GSI](https://github.com/phhusson/treble_experimentations/releases/tag/v109). Check the Wiki for more compatibility details.

It's aimed at SHARP S2 phone, however the repacking kit may also apply to other phones provided with proper *fs_config*, *file_contexts* and *vendor files*.

## Background

[Project Treble](https://source.android.com/devices/architecture) introduces the architecture that decouples the 3rd-party vendor services from the Android core system. That is, a treble-compatible phone could be upgraded to the newer Android version without involving its device manufacturer too much.

To put it in simple words, you can have your `/system` and `/vendor` be independent. A `fastboot flash` to `/system_a`  shouldn't cause the need to flash `/vendor_a` as well.

**SHARP AQUOS S2** is a treble-compatible phone,  and with its latest version of Android 8.0 (_firmware 2.080WW_), it can have its `/system` to be flashed to **AOSP 9.0 GSI** and is workable. However *FIH* seems stopping maintain the phone and there still some components not being well decoupled from its stock `/system` partition. So the project here is try to make those components work in newer Android version by decoupling them more deeply.

## HOW TO BUILD

### Prerequisites

It's developed on **Ubuntu 18.04** and will required the following packages to be installed.

    sudo apt install libpcap2-bin make git

And if you need `make test` to test repacking, should also have the following ones.

    sudo apt install android-tools-fsutils sudo

It also comes with a [Dockerfile](Dockerfile) for testing.

### Build / Repack

Clone the codes, and in the project folder, type `make`

```
~/w/sharp_s2_treble_vendor_image ❯❯❯ make
bin/generate_fs_config.sh vendor > fs_config
cat etc/plat_file_contexts vendor/etc/selinux/nonplat_file_contexts > file_contexts
contrib/make_ext4fs -s -l 1073741824 -L vendor -a /vendor -C fs_config -S file_contexts vendor_95ac217.sparseimg vendor
loaded 3125 fs_config entries
Creating filesystem with parameters:
    Size: 1073741824
    Block size: 4096
    Blocks per group: 32768
    Inodes per group: 8192
    Inode size: 256
    Journal blocks: 4096
    Label: vendor
    Blocks: 262144
    Block groups: 8
    Reserved block group size: 63
Created filesystem with 3135/65536 inodes and 155805/262144 blocks
```
to generate an repacked image from the current git tree.

### Test

Test is achieved by comparing the required file system attributes between the created image and the stock one. In the project folder, type `make test` and it will ask for *root permission* for mounting & umounting target images.

## SHARP AQUOS S2 STOCK 8.0 ➡ AOSP 9.0 (with the built vendor img)

This section describes how the built image can be used or be cooperated with [other GSI ROMs](https://github.com/phhusson/treble_experimentations/wiki/Generic-System-Image-%28GSI%29-list).

In a stock SHARP S2, **there are about 82 partitions on the disk** but not just `/system` and `/vendor` mentioned before. All the partitions somehow interact with each others under the table and thus increase the complexity if some had been modified previously. (might be due to a customized ROM).

**The guide below is only (tested on) for a stock SHARP AQUOS S2 4GB/32GB**, version _2.080WW_. I didn't test on other model/firmware.

### Prerequisites

 * **You should have your _bootloader unlock_**.
 * `sudo apt install android-tools-fastboot`
 * `sudo apt install android-tools-adb` (**if backup needed**)
 * any treble GSI image, for example the [AOSP 9.0 from phhusson](https://github.com/phhusson/treble_experimentations/releases).
 * and the image you built `vendor_xxxxxxx.sparseimg`

Note that on Ubuntu 18.04, install `android-tools-adb` will have **udevd rule** set up for you. The phone should be detected correctly when you plugged in.

### Install to the other slot

S2 is an A/B phone, which means it owns 2 slots for each system partition. We can install our images to the inactive slot and **thus leave the current  stock 8.0 slot untouched**. Shutdown S2, and have it plugged in your PC, press **Volume Down + Power** to boot into *Download mode*.

    > fastboot getvar current-slot
    current-slot: a

Or it could a `b` in your case. It depends on how you upgraded your phone.

Assume you are on a stock 8.0 S2 (_2.080WW_), then by default, the other slot, which is inactive now, would be your previously environment, e.g.  the stock 7.1.1 (_1.35F WW_) . This is how A/B phone works for OTA update. So for this example it would look like this:

| PART | Slot A (In Use) | Slot B|
| -- | -- | -- |
| boot | kernel installed by 2.080 | kernel installed by 1.35F
| system | 8.0 | 7.1.1 |
| vendor | 8.0 | 7.1.1 |

    > fastboot --set-active=b # next boot will from slot b

After setting slot `b`, Android will use `boot_b`, `system_b`, `vendor_b`, and `xxxx_b` partitions to boot. So now we just need to flash both the `system_b` and `vendor_b` to our provided images.

    # use the 9.0 GSI *su* version for easily backup slot a
    > fastboot flash system_b system-arm64-ab-gapps-su.img
    # and then the built vendor.img
    > fastboot flash vendor_b vendor_xxxxxxx.sparseimg

Now it looks like this:

| PART | Slot A | Slot B (In Use)|
| -- | -- | -- |
| boot | kernel installed by 2.080 | kernel installed by 1.35F
| system | 8.0 | **9.0** |
| vendor | 8.0 | **8.0 (this project)** |

And good news is that the **kernel installed by 1.35F** is able to boot into GSI 9.0 as of writing.
Before going to new system, we have to erase user data first because **the partition is shared to both `slot_a` and `slot_b`**, compatibility issues will happen and thus failed to boot.

    # !!!!will lose all your data!!!!
    fastboot format userdata
    # reboot~
    fastboot reboot

After going to a new system, I suggest use `adb` to `su` to backup stock `boot_a`, `system_a`, `vendor_a` just in case. Also suggest update kernel in `boot_b` to be the same as `boot_a`.

    > fastboot flash boot_b boot_a.img.that.you.just.backup

## Authors

* **A3sf6f** - *Initial work*

## Acknowledgments

* [heineken78](https://github.com/Eddie07/kernel_sharp_aquos_s2) @ [XDA](https://forum.xda-developers.com/android/general/sharp-aquos-s2-ss2-sat-thread-t3761071)
* [rkhat2](https://github.com/rkhat2/android-rom-repacker) for `make_ext4fs`
