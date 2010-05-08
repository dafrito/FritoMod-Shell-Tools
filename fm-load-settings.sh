#!/bin/bash
PATH=/bin:/usr/bin:$HOME/bin:$FM_ROOT:${0%/*}

source fm-library.sh

make_root
if [ $root ] && [ -d $root ]; then
	PROJECT=`cat $root/.current-project`
fi

INTERFACE=${INTERFACE='30300'}
PROJECT=${PROJECT-''}
AUTHOR=${AUTHOR-$USER}
VERSION=${VERSION-"Unreleased"}

if [ -e $PROJECT/settings ]; then
	SETTINGS=$PROJECT/settings
	source $SETTINGS
fi

echo "INTERFACE='$INTERFACE'"
echo "PROJECT='$PROJECT'"
echo "AUTHOR='$AUTHOR'"
echo "VERSION='$VERSION'"
