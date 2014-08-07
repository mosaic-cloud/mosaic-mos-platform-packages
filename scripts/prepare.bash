#!/dev/null

if test "${#}" -eq 0 ; then
	exec "${_scripts}/.magic" prepare
	exit 1
fi

if ! test "${#}" -eq 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_package="${1}"
test -d "${_packages}/${_package}"

if test ! -e "${_outputs}" ; then
	mkdir -- "${_outputs}"
fi

exit 0
