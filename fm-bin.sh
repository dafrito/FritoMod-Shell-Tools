#!/bin/bash
PATH=/bin:/usr/bin:$HOME/bin:${0%/*}
FM_ROOT=${0%/*}

source fm-library.sh
source fm-load-settings.sh >/dev/null

command="$root/bin/$1"

shift
if [ -e $command ]; then
	FM_ROOT=$FM_ROOT $command $*
elif [ -e $command.sh ]; then
	FM_ROOT=$FM_ROOT bash $command.sh $*
elif [ -e $command.lua ]; then
	pushd $root >/dev/null
	lua bin/$command.lua $*
	popd >/dev/null
else
	echo "Command not found: $command" 1>&2
fi;
