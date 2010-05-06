#!/bin/bash

source fm-load-settings.sh >/dev/null

NAME=$1
if [ $PROJECT ]; then
	COMPONENT=$PROJECT"_"$NAME
else
	COMPONENT=$NAME
fi;

function build_dir {
	aux=$2
	if [ $aux ]; then
		path=$1_$aux
	else
		path=$1
	fi
	mkdir -p $path
	pushd $path >/dev/null
	. fm-toc.sh $NAME $aux >$path.toc
	popd >/dev/null
}

build_dir $COMPONENT 
build_dir "$COMPONENT" Tests
