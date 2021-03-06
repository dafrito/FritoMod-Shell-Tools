#!/bin/bash
if [ ! "$FM_ROOT" ]; then
	echo "FM_ROOT must be defined" 1>&2
	exit 1
fi
PATH=/bin:/usr/bin:$HOME/bin:$FM_ROOT
source fm-load-settings.sh >/dev/null

dir=`pwd -P`
make_root
if [ ! $root ]; then
	error "not a project"
fi
cd $root

function get_candidates {
	for project in `find .fm/* -maxdepth 0 -type d`; do
		project=${project#*/}
		let l=`echo $project | wc -m`
		for i in `find $project* -maxdepth 0 -type d | trim $l`; do
			if [ $TESTS ] && `echo $i | grep -q _Tests`; then
				echo "$project	$i"
			elif [ ! $TESTS ] && `echo $i | grep -q -v _Tests`; then
				echo "$project	$i"
			fi 
		done;
	done
}


while [ -n "$1" ]; do
	case "$1" in
		-r) RAW=true ;;
		-t) TESTS=true ;;
		-l) LIST=true ;;
		*)
			break
		;;
	esac;
	shift
done

function list {
	IFS='
'
	for c in `get_candidates`; do
		if [ "$RAW" ]; then
			 echo $c
		else
			echo $c | sed "s/	/_/g"
		fi;
	done
	exit 1
}

if [ $LIST ]; then
	list
	exit
fi

if [ ! $1 ]; then
	if [ $TESTS ]; then
		l=`readlink -f . | wc -m`
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
	IFS='
'
	for c in `get_candidates`; do
		if echo $c | cut -f2 | grep -qi $1; then
			echo $c | sed 's/	/_/g'
		fi
	done
}

n=`search $* | wc -l`
if [ 1 -lt $n ]; then
	if [ "$PROJECT" ]; then
		n=`search $* | grep "$PROJECT" | wc -l`
		if [ 1 -eq $n ]; then
			echo "$root/`search $* | grep $PROJECT`"
			exit 0
		fi
	fi
	echo "fm: multiple matches found" 1>&2
	search $* 1>&2
	exit 1
elif [ 0 -eq $n ]; then
	error "fm: no matches found"
	exit 1
fi
echo "$root/`search $*`"
exit 0
