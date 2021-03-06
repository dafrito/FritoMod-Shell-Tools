#!/bin/bash
if [ ! "$FM_ROOT" ]; then
	echo "FM_ROOT must be defined" 1>&2
	exit 1
fi
PATH=/bin:/usr/bin:$HOME/bin:$FM_ROOT

source fm-library.sh

make_root
make_path_from_root `pwd -P`

function make_project {
	if [ $PROJECT ]; then
		return
	fi
	if [ "$root" ] && [ -e $root/.fm ]; then
		if [ -e $root/.fm/default ]; then
			PROJECT=`cat $root/.fm/default`
		elif [ "$path_from_root" ]; then
			PROJECT=${path_from_root%_*}
		elif [ 1 = `find $root/.fm/* -maxdepth 0 -type d  | wc -l` ]; then
			PROJECT=`find $root/.fm/* -maxdepth 0 -type d`
		fi
	fi;
}
make_project


INTERFACE=${INTERFACE='30300'}
AUTHOR=${AUTHOR-$USER}
VERSION=${VERSION-"Unreleased"}

if [ -e $root/.fm/settings ]; then
	source $root/.fm/settings
fi
if [ -e $root/.fm/$PROJECT/settings ]; then
	source $root/.fm/$PROJECT/settings
fi
