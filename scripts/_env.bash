#!/dev/null

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1
export -n BASH_ENV


_workbench="$( readlink -e -- . )"
_repositories="${_workbench}/repositories"
_sources="${_workbench}/sources"
_scripts="${_workbench}/scripts"
_outputs="${_workbench}/.outputs"
_tools="${_workbench}/.tools"
_temporary="/tmp"

_PATH_EXTRA="${PATH_EXTRA:-}"
_PATH_CLEAN="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
_PATH="$( echo "${_tools}/bin:${_PATH_EXTRA}:${_PATH_CLEAN}" | tr -s ':' )"


_rpmbuild_bin="$( PATH="${_PATH}" type -P -- rpmbuild || true )"
if test -z "${_rpmbuild_bin}" ; then
	echo "[ww] missing \`rpmbuild\` (RPM Build) executable in path: \`${_PATH}\`; ignoring!" >&2
	_rpmbuild_bin=rpmbuild
fi

_curl_bin="$( PATH="${_PATH}" type -P -- curl || true )"
if test -z "${_curl_bin}" ; then
	echo "[ww] missing \`curl\` (cURL) executable in path: \`${_PATH}\`; ignoring!" >&2
	_curl_bin=curl
fi

_cpio_bin="$( PATH="${_PATH}" type -P -- cpio || true )"
if test -z "${_cpio_bin}" ; then
	echo "[ww] missing \`cpio\` executable in path: \`${_PATH}\`; ignoring!" >&2
	_cpio_bin=cpio
fi

_tar_bin="$( PATH="${_PATH}" type -P -- tar || true )"
if test -z "${_tar_bin}" ; then
	echo "[ww] missing \`tar\` executable in path: \`${_PATH}\`; ignoring!" >&2
	_tar_bin=tar
fi


_generic_env=(
		PATH="${_PATH}"
		HOME="${HOME:-${_tools}/home}"
		TMPDIR="${_temporary}"
)

_rpmbuild_arguments=(
		-v
)
_rpmbuild_env=(
		"${_generic_env[@]}"
)
_rpmbuild_sources="${HOME}/rpmbuild/SOURCES"
_rpmbuild_rpms="${HOME}/rpmbuild/RPMS"
_rpmbuild_arch=noarch

_curl_arguments=(
		# --progress-bar
		--silent
)
_curl_env=(
		"${_generic_env[@]}"
)


if test -e "${_outputs}/package.timestamp" ; then
	_package_timestamp="$( date -u -r "${_outputs}/package.timestamp" '+%s' )"
else
	_package_timestamp="$( date -u '+%s' )"
fi

_distribution_version="${mosaic_distribution_version:-0.7.0}"
_package_name="$( basename -- "$( readlink -e -- . )" )"
_package_version="${mosaic_package_version:-${_distribution_version}}"
_package_revision="${mosaic_package_revision:-${_package_timestamp}}"
_package_architecture="${_rpmbuild_arch}"


_sed_variables=(
	sed -r
			-e 's#@\{distribution_version\}#'"${_distribution_version}"'#g'
			-e 's#@\{package_name\}#'"${_package_name}"'#g'
			-e 's#@\{package_version\}#'"${_package_version}"'#g'
			-e 's#@\{package_revision\}#'"${_package_revision}"'#g'
			-e 's#@\{package_timestamp\}#'"${_package_timestamp}"'#g'
			-e 's#@\{package_architecture\}#'"${_package_architecture}"'#g'
)
