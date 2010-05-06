#!/bin/bash

source fm-load-settings.sh >/dev/null

command=${PROJECT-'.'}/bin/$1

if [ -e $command ]; then
	$command
	exit $?
fi;
if [ -e $command.sh ]; then
	bash $command.sh
	exit $?
fi;
if [ -e $command.lua ]; then
	lua $command.lua
	exit $?
fi

exit 1
