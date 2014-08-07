#!/dev/null

if ! test "${#}" -le 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_operation="${1:-}"

while read _package ; do
	
	if test -e "${_packages}/${_package}/sources/.disabled" ; then
		continue
	fi
	
	if test "${_operation:-prepare}" == prepare ; then
		echo "[ii] preparing \`${_package}\`..." >&2
		"${_scripts}/prepare" "${_package}"
		echo "[--]" >&2
	fi
	
	if test "${_operation:-build}" == build ; then
		echo "[ii] building \`${_package}\`..." >&2
		"${_scripts}/build" "${_package}"
		echo "[--]" >&2
	fi
	
	if test "${_operation:-package}" == package ; then
		echo "[ii] packaging \`${_package}\`..." >&2
		"${_scripts}/package" "${_package}"
		echo "[--]" >&2
	fi
	
	
	if test "${_operation:-package}" == deploy ; then
		echo "[ii] deploying \`${_package}\`..." >&2
		if test "${pallur_deploy_skip:-true}" != true ; then
			"${_scripts}/deploy" "${_package}"
		else
			echo "[ww]   -- skipped!" >&2
		fi
		echo "[--]" >&2
	fi
	
done < <(
	find "${_packages}" -xdev -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
	| sort
)

exit 0
