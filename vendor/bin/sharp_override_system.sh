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
