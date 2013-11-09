#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test "${_mosaic_deploy_cp:-false}" == true ; then
	test -n "${_mosaic_deploy_cp_store}"
	_mosaic_deploy_cp_target="${_mosaic_deploy_cp_store}/${_package_name}--${_package_version}.rpm"
	echo "[ii] deploying via \`cp\` method to \`${_mosaic_deploy_cp_target}\`..." >&2
	cp -T -- "${_outputs}/package.rpm" "${_mosaic_deploy_cp_target}"
fi

if test "${_mosaic_deploy_curl:-false}" == true ; then
	test -n "${_mosaic_deploy_curl_credentials}"
	test -n "${_mosaic_deploy_curl_store}"
	_mosaic_deploy_curl_target="${_mosaic_deploy_curl_store}/${_package_name}--${_package_version}.rpm"
	echo "[ii] deploying via \`curl\` method to \`${_mosaic_deploy_curl_target}\`..." >&2
	env -i "${_curl_env[@]}" "${_curl_bin}" "${_curl_args[@]}" \
			--anyauth --user "${_mosaic_deploy_curl_credentials}" \
			--upload-file "${_outputs}/package.rpm" \
			-- "${_mosaic_deploy_curl_target}"
fi

exit 0
