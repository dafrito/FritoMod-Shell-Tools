#!/bin/bash
PATH=/bin:/usr/bin:$HOME/bin:$FM_ROOT:${0%/*}

source fm-library.sh

make_root
make_path_using_pwd

if [ "$path_from_root" ]; then
	PROJECT=${path_from_root%_*}
elif [ "$1" ]; then
	PROJECT=$1
fi

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
