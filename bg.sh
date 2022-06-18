#!/bin/bash

q=${@//-*}
query=${q//[0-9]}

while read line ; do
	case $line in
		*-r*) [[ $line =~ $$ ]] || kill `echo $line | cut -d' ' -f2` ;;
	esac
done < <(ps -ef | grep -w 'bg.sh')

_get() {
local url="https://source.unsplash.com/random/\?${query// /,}"

[[ `command -v wget` ]] && wget $url -O $1 || curl $url -Lo $1
}

_set() {
if [[ $(command -v feh) ]] ; then
	feh --bg-fill $1
elif [[ $(command -v xwallpaper) ]] ; then
	xwallpaper --zoom $1
elif [[ $(command -v nitrogen) ]] ; then
	nitrogen --set-zoom-fill $1
else
	echo 'No supported wallpaper setter found' && exit
fi
}

_get ~/img
_set ~/img

[[ $@ =~ --random|-r ]] && {
	n=${q//[a-z]} ; n=${n// }
	n=${n:-30}
	while :; do
		sleep $n
		_get ~/img
		_set ~/img
	done 2>/dev/null & disown
	echo "Images based on query will be set every $n seconds." 
}
