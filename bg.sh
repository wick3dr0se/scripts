#!/bin/bash

q=${@,,}
q=${q/-[a-z]*}
q=${q/-}
query=${q/[0-9]*}

while read line ; do
	case $line in
		*-r*) [[ $line =~ $$ ]] || kill `echo $line | cut -d' ' -f2` ;;
	esac
done < <(ps -ef | grep -w 'bg.sh')

_get() {
local url="https://source.unsplash.com/random/\?$query"

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

if [[ $@ =~ --random|r ]] ; then
	n=${@/[a-z]*}
	n=${n/-}
	n=${n/-}
	echo $n
	while :; do
		sleep ${n:-60}
		_get ~/img
		_set ~/img
	done 2>/dev/null & disown
fi
