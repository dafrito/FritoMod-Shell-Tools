#!/bin/bash

INTERFACE=30300
PROJECT=""
AUTHOR=$USER
VERSION="Unreleased"

if [ -e .settings ]; then
	. .settings
fi

NAME=$1
COMPONENT=$PROJECT_$NAME

function make_toc {
	echo "# Interface: $INTERFACE"
	echo "# Title: $PROJECT - $NAME"
	echo "# Author: $AUTHOR"
	echo "# Version: $VERSION"
}
mkdir -p $COMPONENT
pushd $COMPONENT
make_toc > $COMPONENT.toc
popd 

mkdir -p "$COMPONENT"_Tests
pushd "$COMPONENT"_Tests
make_toc > $COMPONENT.toc
popd
