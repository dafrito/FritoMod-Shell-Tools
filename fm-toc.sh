#!/bin/bash
if [ ! "$FM_ROOT" ]; then
	echo "FM_ROOT must be defined" 1>&2
	exit 1
fi
PATH=/bin:/usr/bin:$HOME/bin:$FM_ROOT

source fm-library.sh

if [ -e "$1" ]; then
	path=$1
else
	path=`fm-search.sh $1`
	if [ ! $? ]; then
		exit 1;
	fi
fi
if [ ! "$path" ]; then
	error "Could not find path: $1"
fi
PROJECT=${path%%_*}
source fm-load-settings.sh >/dev/null

echo "## Interface: $INTERFACE"
if echo $path | grep "_" -q; then
	echo "## Title: $PROJECT: `echo ${path#*_} | sed 's/_/ /g'`"
else
	echo "## Title: $path"
fi;
echo "## Author: $AUTHOR"
echo "## Version: $VERSION"

if [ -e $path/notes ]; then
	egrep "^##" $path/notes
fi;

find $path -name "*.lua" | xargs fm-requires.lua "$path"
