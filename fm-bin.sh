#!/bin/bash
if [ ! "$FM_ROOT" ]; then
	echo "FM_ROOT must be defined" 1>&2
	exit 1
fi
PATH=/bin:/usr/bin:$HOME/bin:$FM_ROOT

source fm-library.sh
make_root

[ $1 ] || error "No command given"
command="$root/commands/$1"

shift
if [ -e $command ]; then
	FM_ROOT=$FM_ROOT $command $*
elif [ -e $command.sh ]; then
	FM_ROOT=$FM_ROOT bash $command.sh $*
elif [ -e $command.lua ]; then
	pushd $root >/dev/null
	lua commands/$command.lua $*
	popd >/dev/null
else
	echo "Command not found: $command" 1>&2
fi;
