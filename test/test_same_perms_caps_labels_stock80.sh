#!/bin/sh
#
# Test a repacked image which should preserve all the permissions, modes, labels and capabilities
# from within the stock 8.0 /vendor partition.
#
# For those newly added files that are not in the stock vendor will simply be ignored.
#

if [ $# -lt 1 ]; then
	echo "Usage: $0 SPARSE_VENDOR_IMAGE"
	exit
fi

VENDOR_IMAGE=$(readlink -f $1)

SIMG2IMG=simg2img
STOCK_FS=fs_config.stock80.txt

script_root=$(dirname $(readlink -f $0))
tmp_name=`basename -s .sparseimg $VENDOR_IMAGE`
tmp_mnt=$tmp_name
tmp_img=$tmp_name.img
tmp_img_fs=$tmp_name.fs_config.txt

cd $script_root
mkdir -p $tmp_mnt
$SIMG2IMG $VENDOR_IMAGE $tmp_img

sudo mount -t ext4 -o ro,loop $tmp_img $tmp_mnt
sudo ../bin/dump_android_filesystem.sh $tmp_mnt > $tmp_img_fs
sudo umount $tmp_mnt

rm $tmp_img
rmdir $tmp_mnt

compare=`diff $tmp_img_fs $STOCK_FS | grep ">"`
if [ "$compare" != "" ]; then
	echo "failed"
	echo "failed fs_config for repacked image is at $(readlink -f $tmp_img_fs)"
	exit 1
fi
echo "OK"
rm $tmp_img_fs
