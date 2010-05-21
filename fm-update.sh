#!/bin/bash
if [ ! "$FM_ROOT" ]; then
	echo "FM_ROOT must be defined" 1>&2
	exit 1
fi
PATH=/bin:/usr/bin:$HOME/bin:$FM_ROOT

source fm-load-settings.sh >/dev/null

make_root
cd $root

if [ ! $root ]; then
	error "fm-update: no project found"
fi

if [ $1 ]; then
	save_toc $1 $2
	exit
fi

IFS='
'
for c in `fm-search.sh -l`; do
	save_toc $c
done
for c in `fm-search.sh -l -t`; do
	save_toc $c
done
for c in `find .fm/* -maxdepth 0 -type d`; do
	if [ -e ${c##*/} ]; then
		save_toc ${c##*/}
	fi
done
