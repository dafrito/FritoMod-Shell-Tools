#!/bin/bash

function make_name {
	name=$1
	if [ ! $1 ]; then
		error "file must be provided"
	elif [ -f $1 ]; then
		name=$1
	elif [ -f $1.lua ]; then
		name=$1.lua
	elif [ -f $1.xml ]; then
		name=$1.xml
	elif [ "$FORCE" ]; then
		if ! `echo $1 | grep -q '\.lua'`; then
			name=$1.lua
		fi
	fi;
}

function make_root {
	pushd . >/dev/null
	root='./'
	while [ ! -e .fm ]; do
		if [ "`pwd`" == '/' ]; then
			popd >/dev/null
			unset root
			return 1
		fi;
		root=$root"../"
		cd ..
	done;
	root=`echo $root | trim -1`
	popd >/dev/null
	return 0
}

function make_path_from_root {
	if [ ! "$root" ]; then
		return
	fi
	len=`readlink -f $root | wc -m`
	let len++
	path_from_root=`readlink -f $1 | trim $len`
	if [ ! "$path_from_root" ]; then
		path_from_root="."
	fi
}

function save_toc {
	if [ -e $1/.no-toc ]; then
		return
	fi
	if [ -e .fm/${1%%_*}/no-toc ]; then
		return
	fi
	tocpath=$1/${1##*/}.toc
	fm-toc.sh $1 >$tocpath.new
	if [ $? ]; then
		mv $tocpath.new $tocpath
	fi
}

function log_with_status {
    log_status=$1
    shift
    [ -r "$log" ] || return 1
    echo "fm: $PROJECT: [$log_status] " $* >>$log
    return $?
}

function log {
    log_with_status "II" $*
}

function warn {
    log_with_status "WW" $*
    [ "$STRICT" ] && exit 1
}

function error {
    log_with_status "EE" $*
    echo $* 1>&2
    [ "$TOLERANT" ] || exit 1
}

