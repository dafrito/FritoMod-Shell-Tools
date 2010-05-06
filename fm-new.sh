#!/bin/bash

source fm-load-settings.sh >/dev/null

NAME=$1
if [ $PROJECT ]; then
	COMPONENT=$PROJECT"_"$NAME
else
	COMPONENT=$NAME
fi;

function make_toc {
	echo "# Interface: $INTERFACE"
	echo "# Title: $PROJECT - $NAME"
	echo "# Author: $AUTHOR"
	echo "# Version: $VERSION"
}
mkdir -p $COMPONENT
pushd $COMPONENT >/dev/null
make_toc > $COMPONENT.toc
popd >/dev/null

mkdir -p "$COMPONENT"_Tests
pushd "$COMPONENT"_Tests >/dev/null
make_toc > $COMPONENT.toc
popd >/dev/null
