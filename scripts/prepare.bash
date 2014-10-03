#!/dev/null

if test "${#}" -eq 0 ; then
	exec "${_scripts}/.magic" prepare
	exit 1
fi

if ! test "${#}" -eq 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_package_name="${1}"
test -d "${_packages}/${_package_name}"

## chunk::3c8b019c663118b00172b22aeae97568::begin ##
if test ! -e "${_temporary}" ; then
	mkdir -- "${_temporary}"
fi
if test ! -e "${_outputs}" ; then
	mkdir -- "${_outputs}"
fi
## chunk::3c8b019c663118b00172b22aeae97568::end ##

exit 0
