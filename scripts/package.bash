#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


echo "[ii] running \`rpmbuild -bb\`..." >&2

env "${_rpmbuild_env[@]}" "${_rpmbuild_bin}" \
		-bb \
		-- "${_outputs}/package.spec"

cp -T -- \
		"${_rpmbuild_rpms}/${_package_architecture}/${_package_name}-${_package_version}-${_package_revision}.${_package_architecture}.rpm" \
		"${_outputs}/package.rpm"

exit 0
