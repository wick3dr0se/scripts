#!/bin/bash

script=${0##*/}
q=${@//-*}
n=${q//[aA-zZ]}
q=${q//[0-9]}
query=${q/ /,}
target='img'

url="https://source.unsplash.com/random/\?$query"

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

[[ ${@,,} =~ --stop|-s ]] && kill $(ps -ef | awk /$script/'{print $2}')

if [[ ${@,,} =~ --random|-r ]] ; then
	while :; do
		wget $url -O ~/$target
		_set ~/$target
		sleep ${n:-60}
	done 2>/dev/null & disown
else
	wget $url -O ~/$target
	_set ~/$target
fi