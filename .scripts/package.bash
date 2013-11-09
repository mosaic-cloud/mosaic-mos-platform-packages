#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


echo "[ii] running \`rpmbuild -bb\`..." >&2

env "${_rpmbuild_env[@]}" "${_rpmbuild_bin}" \
		-bb \
		-- "${_outputs}/package.spec"


exit 0
