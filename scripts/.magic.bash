#!/dev/null

if ! test "${#}" -le 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

_operation="${1:-}"

while read _package_name ; do
	
	if test -e "${_packages}/${_package_name}/sources/.disabled" ; then
		continue
	fi
	
	if test "${_operation:-prepare}" == prepare ; then
		echo "[ii] preparing \`${_package_name}\`..." >&2
		"${_scripts}/prepare" "${_package_name}"
		echo "[--]" >&2
	fi
	
	if test "${_operation:-compile}" == compile ; then
		echo "[ii] compiling \`${_package_name}\`..." >&2
		"${_scripts}/compile" "${_package_name}"
		echo "[--]" >&2
	fi
	
	if test "${_operation:-package}" == package ; then
		echo "[ii] packaging \`${_package_name}\`..." >&2
		"${_scripts}/package" "${_package_name}"
		echo "[--]" >&2
	fi
	
	
	if test "${_operation:-package}" == publish ; then
		echo "[ii] publishing \`${_package_name}\`..." >&2
		"${_scripts}/publish" "${_package_name}"
		echo "[--]" >&2
	fi
	
done < <(
	find "${_packages}" -xdev -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
	| sort
)

exit 0
