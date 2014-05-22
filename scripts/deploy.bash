#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

if test "${pallur_deploy_cp:-false}" == true ; then
	test -n "${pallur_deploy_cp_store}"
	pallur_deploy_cp_target="${pallur_deploy_cp_store}/${_package_name}-${_package_version}-${_package_revision}.${_package_architecture}.rpm"
	echo "[ii] deploying via \`cp\` method to \`${pallur_deploy_cp_target}\`..." >&2
	cp -T -- "${_outputs}/package.rpm" "${pallur_deploy_cp_target}"
fi

if test "${pallur_deploy_curl:-false}" == true ; then
	test -n "${pallur_deploy_curl_credentials}"
	test -n "${pallur_deploy_curl_store}"
	pallur_deploy_curl_target="${pallur_deploy_curl_store}/${_package_name}-${_package_version}-${_package_revision}.${_package_architecture}.rpm"
	echo "[ii] deploying via \`curl\` method to \`${pallur_deploy_curl_target}\`..." >&2
	env -i "${_curl_env[@]}" "${_curl_bin}" "${_curl_args[@]}" \
			--anyauth --user "${pallur_deploy_curl_credentials}" \
			--upload-file "${_outputs}/package.rpm" \
			-- "${pallur_deploy_curl_target}"
fi

if test "${pallur_deploy_rpm:-false}" == true ; then
	test -n "${pallur_deploy_rpm_store}"
	pallur_deploy_rpm_target="${pallur_deploy_rpm_store}/${_package_architecture}/${_package_name}-${_package_version}-${_package_revision}.${_package_architecture}.rpm"
	echo "[ii] deploying via \`rpm\` method to \`${pallur_deploy_rpm_target}\`..." >&2
	cp -T -- "${_outputs}/package.rpm" "${pallur_deploy_rpm_target}"
fi

exit 0
