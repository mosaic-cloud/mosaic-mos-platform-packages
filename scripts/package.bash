#!/dev/null

if test "${#}" -eq 0 ; then
	exec "${_scripts}/.magic" package
	exit 1
fi

if ! test "${#}" -eq 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_package_name="${1}"
test -d "${_packages}/${_package_name}"

env "${_python2_env[@]}" \
			mpb_package_name="${_package_name}" \
			mpb_package_version="${_package_version}" \
			mpb_resources_cache="${_artifacts_cache}" \
		"${_python2_bin}" "${_scripts}/package.py" \
				"${_packages}/${_package_name}/sources" \
				"${_outputs}/${_package_name}.rpm"

if test -n "${_artifacts_cache}" ; then
	cp -T -- "${_outputs}/${_package_name}.rpm" "${_artifacts_cache}/${_package_name}--${_package_version}.rpm"
fi

exit 0
