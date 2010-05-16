#!/bin/bash
PATH=/bin:/usr/bin:$HOME/bin:$FM_ROOT:${0%/*}

source fm-library.sh

make_root
make_path_using_pwd

function make_project {
	if [ $PROJECT ]; then
		return
	fi
	if [ "$path_from_root" ]; then
		PROJECT=${path_from_root%_*}
	elif [ "$root" ] && [ -e $root/.fm ]; then
		if [ 1 = `find $root/.fm/* -maxdepth 0 -type d  | wc -l` ]; then
			PROJECT=`find $root/.fm/* -maxdepth 0 -type d`
		elif [ -e $root/.fm/default ]; then
			PROJECT=`cat $root/.fm/default`
		fi
	fi;
}
make_project

INTERFACE=${INTERFACE='30300'}
AUTHOR=${AUTHOR-$USER}
VERSION=${VERSION-"Unreleased"}

if [ -e $root/.fm/$PROJECT/settings ]; then
	SETTINGS=$root/.fm/$PROJECT/settings
	source $SETTINGS
fi

echo "INTERFACE='$INTERFACE'"
echo "PROJECT='$PROJECT'"
echo "AUTHOR='$AUTHOR'"
echo "VERSION='$VERSION'"
