#!/dev/null

if ! test "${#}" -eq 0 ; then
	echo "[ee] invalid arguments; aborting!" >&2
	exit 1
fi


test -e "${_outputs}/rootfs"


echo "[ii] cleaning old artifacts..." >&2
for _path in \
			"${_outputs}/rootfs.cpio" "${_outputs}/rootfs.tar"
do
	if test -d "${_path}" ; then
		rmdir -- "${_path}"
	elif test -e "${_path}" ; then
		rm -- "${_path}"
	fi
done


echo "[ii] creating rootfs CPIO archive..." >&2
(
	cd -- "${_outputs}/rootfs"
	exec find . -xdev -depth -print0
) | \
(
	cd -- "${_outputs}/rootfs"
	exec env -i "${_generic_env[@]}" "${_cpio_bin}" \
		--create \
		--format newc \
		--null \
		--quiet
) \
>|"${_outputs}/rootfs.cpio"

#echo "[ii] creating rootfs TAR archive..." >&2
#(
#	cd -- "${_outputs}/rootfs"
#	exec find . -xdev -depth -print0
#) | \
#(
#	cd -- "${_outputs}/rootfs"
#	exec env -i "${_generic_env[@]}" "${_tar_bin}" \
#		--create \
#		--format gnu \
#		--numeric-owner \
#		--null --files-from /dev/stdin \
#		--no-recursion
#) \
#>|"${_outputs}/rootfs.tar"


exit 0
