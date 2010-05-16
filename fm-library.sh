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

function make_path_using_pwd {
	if [ ! "$root" ]; then
		return
	fi
	l=`readlink -f $root | wc -m`
	let l++
	pwd=`pwd -P`
	path_from_root=`readlink -f "$pwd" | trim $l`
}

function make_path_from_root {
	l=`readlink -f $root | wc -m`
	let l++
	path_from_root=`readlink -f $name | trim $l`
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

