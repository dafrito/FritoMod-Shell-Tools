#!/bin/bash

source fm-load-settings.sh >/dev/null

NAME=$1
if [ $PROJECT ]; then
	COMPONENT=$PROJECT"_"$NAME
else
	COMPONENT=$NAME
fi;

function build_dir {
	mkdir -p $1
	pushd $1 >/dev/null
	fm-toc.sh > $1.toc
	popd >/dev/null
}

build_dir $COMPONENT
build_dir "$COMPONENT"_Tests
