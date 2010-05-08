#!/bin/bash
ATH=/bin:/usr/bin:$HOME/bin:${0%/*}

function make_title {
	if [ $PROJECT ] && [ $PROJECT = $1 ] && [ ! $2 ]; then
		title=$PROJECT
	else
		prefix=${PROJECT+$PROJECT": "}
		name=$1
		postfix=${2+ - $2}
		title=$prefix""$name""$postfix
	fi
}

function make_path {
	if [ $PROJECT ] && [ $PROJECT = $1 ] && [ ! $2 ]; then
		path=$PROJECT
	else
		prefix=${PROJECT+$PROJECT"_"}
		name=$1
		postfix=${2+_$2}
		path=$prefix""$name""$postfix
	fi
}

function make_root {
	pushd . >/dev/null
	root='./'
	while [ ! -e .current-project ]; do
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

function save_toc {
	make_path $1 $2
	fm-toc.sh $1 $2 >$path/$path.toc.new
	if [ $? ]; then
		mv $path/$path.toc.new $path/$path.toc
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

