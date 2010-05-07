#!/bin/bash
PATH=/bin:/usr/bin:$HOME/bin:${0%/*}

function make_title {
	prefix=${PROJECT+$PROJECT": "}
	name=$1
	postfix=${2+ - $2}
	title=$prefix""$name""$postfix
}

function make_path {
	prefix=${PROJECT+$PROJECT"_"}
	name=$1
	postfix=${2+_$2}
	path=$prefix""$name""$postfix
}

function save_toc {
	make_path $1 $2
	source fm-toc.sh $1 $2 >$path/$path.toc.new
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

