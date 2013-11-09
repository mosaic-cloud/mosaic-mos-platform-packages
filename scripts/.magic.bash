#!/dev/null

if ! test "${#}" -le 1 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


while read _package ; do
	
	echo "[ii] preparing \`${_package}\`..." >&2
	"${_workbench}/packages/${_package}/scripts/prepare"
	echo "[--]" >&2
	
	echo "[ii] packaging \`${_package}\`..." >&2
	"${_workbench}/packages/${_package}/scripts/package"
	echo "[--]" >&2
	
	echo "[ii] deploying \`${_package}\`..." >&2
	if test "${_mosaic_deploy_skip:-true}" != true ; then
		"${_workbench}/packages/${_package}/scripts/deploy"
	else
		echo "[ww]   -- skipped!" >&2
	fi
	echo "[--]" >&2
	
done < <(
	find "${_workbench}/packages" -xdev -mindepth 1 -maxdepth 1 -type d -printf '%f\n'
)


if test "${_mosaic_deploy_skip:-true}" != true -a "${_mosaic_deploy_rpm:-false}" == true ; then
	echo "[ii] updating repository..." >&2
	test -n "${_mosaic_deploy_rpm_store}"
	createrepo -- "${_mosaic_deploy_rpm_store}"
	echo "[--]" >&2
fi


exit 0
