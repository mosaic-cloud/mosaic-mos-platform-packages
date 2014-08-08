#!/dev/null

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1
export -n BASH_ENV

_workbench="$( readlink -e -- . )"
_packages="${_workbench}/packages"
_scripts="${_workbench}/scripts"
_tools="${pallur_tools:-${_workbench}/.tools}"
_temporary="${pallur_temporary:-${pallur_TMPDIR:-${TMPDIR:-/tmp}}}"
_outputs="${_temporary}/$( basename -- "${_workbench}" )--outputs--$( readlink -e -- "${_workbench}" | tr -d '\n' | md5sum -t | tr -d ' \n-' )"

_PATH="${pallur_PATH:-${_tools}/bin:${PATH}}"
_HOME="${pallur_HOME:-${HOME}}"
_TMPDIR="${pallur_TMPDIR:-${TMPDIR:-${_temporary}}}"

_python2_bin="$( PATH="${_PATH}" type -P -- python2 || true )"
if test -z "${_python2_bin}" ; then
	echo "[ee] missing \`python2\` executable in path: \`${_PATH}\`; ignoring!" >&2
	_python2_bin=false
fi

_generic_env=(
		PATH="${_PATH}"
		HOME="${_HOME}"
		TMPDIR="${_TMPDIR}"
)

_python2_args=(
		-B -E
)
_python2_env=(
		"${_generic_env[@]}"
)

_package_version="${pallur_distribution_version:-0.7.0_dev}"
_artifacts_cache="${pallur_artifacts:-}"
