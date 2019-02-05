#!/vendor/bin/sh

#Run initCDA
/vendor/bin/UpdateCDA -r -o /hidden/data/CDALog/ID
/vendor/bin/UpdateCDA -r -o /vendor/hidden/data/CDALog/ID
setprop sys.force.Idmap true
/vendor/bin/InitCDA -all
