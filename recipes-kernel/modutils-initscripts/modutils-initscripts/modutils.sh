#!/bin/sh
#==================================================
#
# updated: 03/22/20 Reach Technology
#
# this script controls a system critical function
# and must not be put under control of chkconfig
#
#==================================================

LOAD_MODULE=modprobe
[ -f /proc/modules ] || exit 0
[ -f /etc/modules ] || [ -d /etc/modules-load.d ] || exit 0
[ -e /sbin/modprobe ] || LOAD_MODULE=insmod

if [ ! -f /lib/modules/`uname -r`/modules.dep ]; then
	[ "$VERBOSE" != no ] && echo "Calculating module dependencies ..."
	depmod -Ae
fi

loaded_modules=" "

process_file() {
	file=$1

	(cat $file; echo; ) |
	while read module args
	do
		case "$module" in
			\#*|"") continue ;;
		esac
		[ -n "$(echo $loaded_modules | grep " $module ")" ] && continue
		[ "$VERBOSE" != no ] && echo -n "$module "
		eval "$LOAD_MODULE $module $args >/dev/null 2>&1"
		loaded_modules="${loaded_modules}${module} "
	done
}

[ "$VERBOSE" != no ] && echo -n "Loading modules: "
[ -f /etc/modules ] && process_file /etc/modules

[ -d /etc/modules-load.d ] || exit 0

for f in /etc/modules-load.d/*.conf; do
	process_file $f
done
[ "$VERBOSE" != no ] && echo

exit 0
