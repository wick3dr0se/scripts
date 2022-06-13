#!/bin/bash

_out(){
	printf "\033[1;40;97m%s\033[0m\n" "$1"
}

4bit() {
	echo -ne "\033[1;${1}${i}m${1}${i}\033[0m"
}


_out '4-bit ANSI escape sequence'
_out 'Usage: \033[1;??m .. \033[0m'
for i in {0..7} ; do
	4bit 3 # FG code 
	4bit 4 # BG code
	4bit 9 # FG code
	4bit 10 # BG code
done

8bit() { # 256 colors
	echo -ne "\033[${1}8;5;${i}m${i}\033[0m"
}

echo ; echo
_out '8-bit ANSI escape sequence'
_out 'Usage: \033[?8;5;???m .. \033[0m'
for i in {0..256} ; do
	8bit 3 #FG code
	8bit 4 #BG code
done
