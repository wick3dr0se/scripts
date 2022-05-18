#!/bin/bash

while read line ; do
	[[ $line =~ : ]] ||
	case $line in
		*-*) device=$line
			echo ${device%%-*}
			while read device temp ; do
				[[ $device =~ - ]] && echo ${device%%-*}
				[[ $temp =~ ° ]] && echo $device ${temp/+} && echo
			done ;;
	esac
done < <(sensors -fA)
