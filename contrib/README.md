# CONTRIBUTION
 * `make_ext4fs`: a Linux copy from https://github.com/rkhat2/android-rom-repacker/releases/tag/android-8-v4
 * _SHA1(`make_ext4fs`)_ = `c47658bd7ca3078b5d4c9251f33c59cd4763b05e`

## `make_ext4fs`

If you use `make_ex4fs` from the Ubuntu's `android-tools-fsutils` (_**5.1.1.r38-1.1**_), you will encounter a bug when making an image that both the **file_contexts** and **capabilities** options are involved:

> `make_ext4fs -s -l 1073741824 -L vendor -a /vendor -C fs_config -S file_contexts vendor_c6d9a78.sparseimg vendor`
> **error: xattr_assert_sane: BUG: extended attributes are not sorted**

It's a known bug and had been fixed in the upstream and thus the [copy](https://github.com/rkhat2/android-rom-repacker/releases/tag/android-8-v4) from the https://github.com/rkhat2/android-rom-repacker/ works without problems. Thanks to **rkha2**.
