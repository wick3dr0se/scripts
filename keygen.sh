#!/bin/bash

file=${@##-*}
file=${file// }
file=${file:-key}

prefix=${file%.gpg}
suffix=${file#$prefix}
[[ ! $suffix ]] && file="${file}.gpg"


encrypt() {
if [[ -f ${file} ]] ; then
while read line ; do
	echo $line >> ${prefix}.txt
done < <(gpg --decrypt ${file} 2>/dev/null)
fi

read -p 'Specify a password length (fallback 8): ' n
n=${n//[a-zA-Z]}
read -p 'Label for generated password? ' label

while read line ; do
	echo "${label}: ${line//['/'+]}" >> ${prefix}.txt
	break	
done < <(cat /dev/urandom | base64 -w ${n:-8})

read -p 'Enter a (new) password to handle decryption: ' encrypt_pass
gpg --yes --batch --passphrase $encrypt_pass --output ${file} --symmetric ${prefix}.txt && rm -Rf ${prefix}.txt
echo "$file generated!"
}

decrypt() {
if [[ -f ${file} ]] ; then
	gpg --decrypt ${file} 2>/dev/null
else
	echo "${file} not found. Aborting.."
fi
}

trap "echo ; echo 'Singal interrupt captured. Aborting..' && rm -Rf ${prefix}.txt && exit 130" SIGINT

case ${@,,} in
	*'-d'*|*'--decrypt'*) decrypt && exit ;;
esac

encrypt
