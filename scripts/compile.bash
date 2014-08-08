#!/dev/null

if test "${#}" -eq 0 ; then
	exec "${_scripts}/.magic" build
	exit 1
fi

if ! test "${#}" -eq 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_package_name="${1}"
test -d "${_packages}/${_package_name}"

exit 0
