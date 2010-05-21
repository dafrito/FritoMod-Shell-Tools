#!/bin/bash
if [ ! "$FM_ROOT" ]; then
	echo "FM_ROOT must be defined" 1>&2
	exit 1
fi
PATH=/bin:/usr/bin:$HOME/bin:$FM_ROOT

mkdir -p .fm/$1
touch .fm/$1/settings
touch .fm/settings
