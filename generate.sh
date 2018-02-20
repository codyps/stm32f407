#! /bin/sh
d="$(dirname "$0")"
t=
on_exit() {
	if [ "$t" ]; then
		rm -f "$t"
	fi
}
if [ $# -ne 1 ]; then
	>&2 echo "usage: $0 TARGET.svd"
	exit 1
fi


trap on_exit EXIT
t=$(mktemp)

cp "$1" "$t"
patch "$t" STM32F407.patch
svd2rust -i "$t" | rustfmt >"$d/src/lib.rs"
