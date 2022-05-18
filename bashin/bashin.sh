#!/bin/bash

write() {
for i in {0..7} ; do
	MSG[1]='ERROR' ; MSG[6]='SUCESS'
	[[ $i = $2 ]] && printf "[\033[1;3${i}m ${MSG[$2]} \033[0m] %s\n" "$1"
done
}

declare -A flag
[[ $# = 0 ]] && write 'No arguments' 1 ||
for col in $@ ; do
	[[ $col =~ ^--[a-z]|^-[a-z]$ ]] && flag=${col,,} || query="${col%.sh}.sh"
	[[ ! $flag ]] && [[ $query ]] && echo '#!/bin/bash' > $query
	shift
	case $flag in # convert long flags
		--args) set -- $@ -a ;;
		--help|--usage) set -- $@ -h ;;
		*) set -- $@ $flag ;;
	esac
	OPTFIND=1
	while getopts 'ahu' opt ; do # handle flags
		case $opt in
			a) cat args.txt > $query ;;
			h|u) cat <<USAGE
help
USAGE
			;;
			?) write 'Bad argument' 1 ;;
		esac
		break
	done
	shift `expr $OPTFIND - 1`

done
