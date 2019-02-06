#!/usr/bin/perl
#
# Convert getcap(8) cap texts to its numeric representation form.
#
# Mapping and bitwise algorithm are transcribed from
# https://android.googlesource.com/platform/system/core/+/android-9.0.0_r30/libcutils/include/private/android_filesystem_capability.h
#
use strict;

my $getcap = 'getcap';

my %map = (
	'CAP_CHOWN' =>  0,
	'CAP_DAC_OVERRIDE' =>  1,
	'CAP_DAC_READ_SEARCH' =>  2,
	'CAP_FOWNER' =>  3,
	'CAP_FSETID' =>  4,
	'CAP_KILL' =>  5,
	'CAP_SETGID' =>  6,
	'CAP_SETUID' =>  7,
	'CAP_SETPCAP' =>  8,
	'CAP_LINUX_IMMUTABLE' =>  9,
	'CAP_NET_BIND_SERVICE' =>  10,
	'CAP_NET_BROADCAST' =>  11,
	'CAP_NET_ADMIN' =>  12,
	'CAP_NET_RAW' =>  13,
	'CAP_IPC_LOCK' =>  14,
	'CAP_IPC_OWNER' =>  15,
	'CAP_SYS_MODULE' =>  16,
	'CAP_SYS_RAWIO' =>  17,
	'CAP_SYS_CHROOT' =>  18,
	'CAP_SYS_PTRACE' =>  19,
	'CAP_SYS_PACCT' =>  20,
	'CAP_SYS_ADMIN' =>  21,
	'CAP_SYS_BOOT' =>  22,
	'CAP_SYS_NICE' =>  23,
	'CAP_SYS_RESOURCE' =>  24,
	'CAP_SYS_TIME' =>  25,
	'CAP_SYS_TTY_CONFIG' =>  26,
	'CAP_MKNOD' =>  27,
	'CAP_LEASE' =>  28,
	'CAP_AUDIT_WRITE' =>  29,
	'CAP_AUDIT_CONTROL' =>  30,
	'CAP_SETFCAP' =>  31,
	'CAP_MAC_OVERRIDE' =>  32,
	'CAP_MAC_ADMIN' =>  33,
	'CAP_SYSLOG' =>  34,
	'CAP_WAKE_ALARM' =>  35,
	'CAP_BLOCK_SUSPEND' =>  36,
	'CAP_AUDIT_READ' =>  37
);

main();

sub main {
	my $result = `$getcap @ARGV`;
	die "Failed to execute $getcap\n" if $?;

	# no caps found
	unless ($result) {
		printf "0x0\n";
		return;
	}

	my @lines = split /\n/, $result;
	for my $line (@lines) {
		if ($line =~ /\S+ = (\S+)\+ep/) {
			my @caps = split /,/, $1;
			my $hex = 0;
			for my $cap (@caps) {
				unless (exists $map{uc $cap}) {
					die "Unsupported capability found: $cap\n";
				}
				$hex = $hex | (1 << $map{uc $cap});
			}
			printf "0x%x\n", $hex;
		}
	}
}
