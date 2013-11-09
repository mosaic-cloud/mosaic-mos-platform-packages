#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


test ! -e "${_outputs}/rootfs"
mkdir -m 0755 -- "${_outputs}/rootfs"


exit 0
