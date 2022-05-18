#!/bin/bash

[[ $1 ]] &&
kill $(ps -ef | awk /$@/'{print $2}')
