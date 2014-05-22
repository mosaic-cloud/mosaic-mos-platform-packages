#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


if test -e "${_rpmbuild_rpms}/${_package_architecture}/${_package_name}-${_package_version}-${_package_revision}.${_package_architecture}.rpm" ; then
	cp -T -- \
			"${_rpmbuild_rpms}/${_package_architecture}/${_package_name}-${_package_version}-${_package_revision}.${_package_architecture}.rpm" \
			"${_outputs}/package.rpm"
elif test -e "${_rpmbuild_rpms}/${_package_architecture}/${_package_name}-${_distribution_version}-${_package_version}-${_package_revision}.${_package_architecture}.rpm" ; then
	cp -T -- \
			"${_rpmbuild_rpms}/${_package_architecture}/${_package_name}-${_distribution_version}-${_package_version}-${_package_revision}.${_package_architecture}.rpm" \
			"${_outputs}/package.rpm"
else
	false
fi


echo "[ii] packaged \`${_package_name}-${_package_version}-${_package_revision}.${_package_architecture}\`;" >&2


exit 0
