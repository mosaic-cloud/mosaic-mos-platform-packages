#!/dev/null

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1
export -n BASH_ENV


_workbench="$( readlink -e -- . )"
_sources="${_workbench}/sources"
_scripts="${_workbench}/scripts"
_outputs="${_workbench}/.outputs"
_tools="${pallur_tools:-${_workbench}/.tools}"
_temporary="${pallur_temporary:-${pallur_TMPDIR:-${TMPDIR:-/tmp}}}"

_PATH="${pallur_PATH:-${_tools}/bin:${PATH}}"
_HOME="${pallur_HOME:-${HOME}}"
_TMPDIR="${pallur_TMPDIR:-${TMPDIR:-${_temporary}}}"

_PATH_EXTRA="${PATH_EXTRA:-}"
_PATH_CLEAN="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
_PATH="$( echo "${_PATH}:${_PATH_EXTRA}:${_PATH_CLEAN}" | tr -s ':' )"


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

_zip_bin="$( PATH="${_PATH}" type -P -- zip || true )"
if test -z "${_zip_bin}" ; then
	echo "[ww] missing \`zip\` executable in path: \`${_PATH}\`; ignoring!" >&2
	_zip_bin=zip
fi

_unzip_bin="$( PATH="${_PATH}" type -P -- unzip || true )"
if test -z "${_unzip_bin}" ; then
	echo "[ww] missing \`unzip\` executable in path: \`${_PATH}\`; ignoring!" >&2
	_unzip_bin=unzip
fi


_generic_env=(
		PATH="${_PATH}"
		HOME="${_HOME}"
		TMPDIR="${_TMPDIR}"
)

_rpmbuild_arguments=(
		--quiet
)
_rpmbuild_env=(
		"${_generic_env[@]}"
)
_rpmbuild_sources="${_HOME}/rpmbuild/SOURCES"
_rpmbuild_rpms="${_HOME}/rpmbuild/RPMS"
_rpmbuild_arch=x86_64

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

_distribution_version="${pallur_distribution_version:-0.7.0_dev}"
_package_name="$( basename -- "$( readlink -e -- . )" )"
_package_version="${pallur_package_version:-${_distribution_version}}"
_package_revision="${pallur_package_revision:-${_package_timestamp}}"
_package_architecture="${_rpmbuild_arch}"


_sed_variables=(
	sed -r
			-e ': loop'
			-e 's#@\{distribution_version\}#'"${_distribution_version}"'#g'
			-e 's#@\{package_name\}#'"${_package_name}"'#g'
			-e 's#@\{package_version\}#'"${_package_version}"'#g'
			-e 's#@\{package_revision\}#'"${_package_revision}"'#g'
			-e 's#@\{package_timestamp\}#'"${_package_timestamp}"'#g'
			-e 's#@\{package_architecture\}#'"${_package_architecture}"'#g'
)

while read _variable _variable_value ; do
	_sed_variables+=(
			-e 's#@\{'"${_variable}"'\}#'"${_variable_value}"'#g'
	)
done < <(
	if test -e "${_sources}/variables.txt" ; then
		cat -- "${_sources}/variables.txt"
	fi
)

_sed_variables+=(
		-e 't loop'
)
