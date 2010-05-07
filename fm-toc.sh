#!/bin/bash
PATH=/bin:/usr/bin:$HOME/bin:${0%/*}

source fm-library.sh
source fm-load-settings.sh >/dev/null

if [ $PROJECT ] && [ $PROJECT = $1 ] && [ ! $2 ]; then
	path=$PROJECT
else
	make_path $1 $2
fi
make_title $1 $2

echo "## Interface: $INTERFACE"
echo "## Title: $title"
echo "## Author: $AUTHOR"
echo "## Version: $VERSION"

find $path -name "*.lua" | xargs fm-requires.lua $path
