#!/bin/bash

write() {
for i in {0..7} ; do
	[[ $i = $3 ]] && printf "\033[1;${BG}3${i}m%s\033[0m%s" "$1" "$2"
done
}

_img() {
if [[ `command -v viu` ]] ; then
        echo ; viu --width 10 --height 5 "$col"
        write "$1" '' 7 ; echo
elif [[ `command -v timg` ]] ; then
        echo ; timg -g10x5 "$col"
        write "$1" '' 7 ; echo
elif [[ `command -v lsix` ]] ; then
        echo ; lsix -geometry 10x5 "$col"
        write "$1" '' 7 ; echo
elif [[ `command -v catimg` ]] ; then
        echo ; catimg -w 20 "$col"
        write "$1" '' 7 ; echo
else
	echo 'No thumbnail viewer found' && exit
fi
}

# convert long flags to short flags
for arg in "$@" ; do
	shift
	case "$arg" in
		--all) set -- $@ -a ;;
		--help|--usage) set --$@ -h ;;
		*) set -- $@ $arg ;;
	esac
done

# handle flags
flags=('-F') # flags used by default
OPTFIND=1
while getopts 'ahu' opt ; do
	case $opt in
		a) flags+=('-A') ;;
		u|h|*) cat <<USAGE
flag | usage
-a, --all ... list all hidden files and directories
USAGE
exit ;;
	esac
done
shift `expr $OPTFIND - 1`

for col in $@ ; do
	[[ $col =~ ^-[a-z] ]] || _in=$col
	case $col in
		*.sh|*.txt|*.md) cat $col ;;
	esac
done

for col in `ls ${flags[@]} $_in` ; do
	case $col in
		*/) write "${col%/}" '/  ' 4 ;;
		*\*|*.sh) write "${col%\*}" '*  ' 3 ;;
		*@) write "${col%@}" '@  ' 7 ;;
		*.txt|*.md) write "${col##/*}" '  ' 7 ;;
		*) [[ `file $col` =~ image ]] && _img "${col##*/}"  || write "$col" '  ' 7
		;;
	esac
done
echo
