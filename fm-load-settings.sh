#!/bin/bash
PATH=/bin:/usr/bin:$HOME/bin:$FM_ROOT:${0%/*}

source fm-library.sh

make_root

INTERFACE=${INTERFACE='30300'}
PROJECT=${1-''}
AUTHOR=${AUTHOR-$USER}
VERSION=${VERSION-"Unreleased"}

if [ -e $root/$PROJECT/settings ]; then
	SETTINGS=$root/$PROJECT/settings
	source $SETTINGS
fi

echo "INTERFACE='$INTERFACE'"
echo "PROJECT='$PROJECT'"
echo "AUTHOR='$AUTHOR'"
echo "VERSION='$VERSION'"
