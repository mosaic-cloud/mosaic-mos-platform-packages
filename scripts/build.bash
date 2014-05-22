#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


"${_scripts}/assemble"
"${_scripts}/bundle"


echo "[ii] preparing \`rpmbuild\` spec..." >&2

"${_sed_variables[@]}" \
	>|"${_outputs}/package.spec" \
	<"${_sources}/rpmspec.txt"


echo "[ii] preparing \`rpmbuild\` sources..." >&2

if test ! -e "${_rpmbuild_sources}" ; then
	mkdir -- "${_rpmbuild_sources}"
fi

cp -T -- \
		"${_outputs}/rootfs.cpio" \
		"${_rpmbuild_sources}/${_package_name}--${_package_version}-${_package_revision}-${_package_architecture}--rootfs.cpio"


echo "[ii] running \`rpmbuild -bb\`..." >&2

env "${_rpmbuild_env[@]}" "${_rpmbuild_bin}" \
		-bb \
		--clean \
		"${_rpmbuild_arguments[@]}" \
		-- "${_outputs}/package.spec"


exit 0
