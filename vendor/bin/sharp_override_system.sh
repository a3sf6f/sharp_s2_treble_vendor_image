#!/vendor/bin/sh

# Apps found in phh's AOSP 8.1 v28
targets="
/system/app/BasicDreams
/system/app/CalculatorGoogle
/system/app/CalendarGooglePrebuilt
/system/app/Camera2
/system/app/Email
/system/app/Gallery2
/system/app/LiveWallpapersPicker
/system/app/messaging
/system/app/Music
/system/app/OpenWnn
/system/app/PhotoTable
"

for t in $targets; do
        test -d $t && mount -o bind /vendor/sharp_overrides/empty $t
done

for t in $(find /system/app -type d -name "treble*" | grep -e samsung -e xiaomi -e oneplus); do
	mount -o bind /vendor/sharp_overrides/empty $t || true
done

# The duplicate causes it unable to boot for AOSP 8.1 v28
target=/system/overlay/treble-overlay-sharp-s2.apk
if [ -f $target ] && [ -f /vendor/overlay/treble-overlay-sharp-s2.apk ]; then
	mount -o bind /vendor/sharp_overrides/empty/empty $target
fi
