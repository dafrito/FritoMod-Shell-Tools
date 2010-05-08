#!/bin/bash
PATH=/bin:/usr/bin:$HOME/bin:$FM_ROOT:${0%/*}
source fm-load-settings.sh >/dev/null

[ $PROJECT ] || error "no project found";

dir=`pwd -P`
make_root
cd $root

function get_candidates {
	let l=`echo $PROJECT | wc -m`+1
	for i in `find $PROJECT* -maxdepth 0 -type d | trim $l`; do
		if [ $TESTS ] && `echo $i | grep -q _Tests`; then
			echo $i
		elif [ ! $TESTS ] && `echo $i | grep -q -v _Tests`; then
			echo $i
		fi 
	done;
}

case $1 in
	-t)
		TESTS=true
		shift
	;;
	-l)
		get_candidates 1>&2
		exit 1
	;;
esac;

if [ ! $1 ]; then
	if [ $TESTS ]; then
		l=`readlink -f . | wc -m`
		let l++
		path=`readlink -f "$dir" | trim $l`
		if `echo $path | grep -q '/'`; then
			comp=${path%%/*}
			comp_path=${path#*/}
		else
			comp=$path
			unset comp_path
		fi
		if echo "$comp" | grep -q _Tests; then
			if [ -d ${comp%_*} ]; then
				echo $root/${comp%_*}/$comp_path
				exit 0
			fi;
		else
			if [ -d $comp"_Tests" ]; then
				echo $root/$comp"_Tests"/$comp_path
				exit 0
			fi;
		fi
	fi
	exit 1
fi

function search {
	get_candidates | grep -i $1
}

n=`search $* | wc -l`
if [ 1 -lt $n ]; then
	echo "fm: multiple matches found" 1>&2
	search $* 1>&2
	exit 1
elif [ 0 -eq $n ]; then
	error "fm: no matches found"
	exit 1
fi
echo $root"/"$PROJECT"_"`search $*`
exit 0
