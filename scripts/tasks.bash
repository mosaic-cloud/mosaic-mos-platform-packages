#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi

while read _package_name ; do
	if test -e "${_packages}/${_package_name}/sources/.disabled" ; then
		continue
	fi
	cat <<EOS

${_package_name}-rpm@requisites : \
		pallur-packages@python-${_python_version} \
		pallur-packages@rpm \
		pallur-environment

${_package_name}-rpm@prepare : ${_package_name}-rpm@requisites ${_package_name}@package
	!exec ${_scripts}/prepare ${_package_name}

${_package_name}-rpm@package : ${_package_name}-rpm@prepare
	!exec ${_scripts}/package ${_package_name}

${_package_name}-rpm@publish : ${_package_name}-rpm@package
	!exec ${_scripts}/publish ${_package_name}

EOS
done < <(
	find "${_packages}" -xdev -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
	| sort
)

cat <<EOS

mosaic-platform-core@package : mosaic-node-boot@package
mosaic-platform-java@package : mosaic-node-boot@package

EOS

exit 0
