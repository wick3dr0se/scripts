#!/bin/bash

write() {
for i in {0..7} ; do
	[[ $i = $3 ]] && printf "%s\033[1;3${i}m%s\033[0m\n" "$1" "$2"
done
}

while read line ; do
	[[ $line =~ : ]] ||
	case $line in
		*-*) device=$line
			echo ${device%%-*}
			while read device temp ; do
				[[ $device =~ - ]] && echo ${device%%-*}
				if [[ $temp =~ ° ]] ; then
					temp=${temp/.*} && temp=${temp/+}


					if (($temp < 100)) ; then 
						write "$device" "$temp" 4
					elif (($temp < 125)) ; then
						write "$device" "$temp" 2
					elif (($temp < 150)) ; then
						write "$device" "$temp" 3
					elif (($temp < 190)) ; then
						write "$device" "$temp" 1
						(($temp > 190)) && echo 'Temperature at critical level' 
					fi
				fi
			done ;;
	esac
done < <(sensors -fA)
