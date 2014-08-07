#!/dev/null

if test "${#}" -eq 0 ; then
	exec "${_scripts}/.magic" package
	exit 1
fi

if ! test "${#}" -eq 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_package="${1}"
test -d "${_packages}/${_package}"

env "${_python2_env[@]}" \
		"${_python2_bin}" "${_scripts}/package.py" \
				"${_packages}/${_package}/sources" \
				"${_outputs}/${_package}.rpm"

exit 0
