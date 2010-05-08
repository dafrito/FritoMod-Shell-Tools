#!/bin/bash
PATH=/bin:/usr/bin:$HOME/bin:${0%/*}
FM_ROOT=${0%/*}

source fm-library.sh
source fm-load-settings.sh >/dev/null

if [ -d $root/$PROJECT ]; then
	command="$root/$PROJECT/bin/$1"
else
	command="$root/bin/$1"
fi
shift
if [ -e $command ]; then
	FM_ROOT=$FM_ROOT $command $*
elif [ -e $command.sh ]; then
	FM_ROOT=$FM_ROOT bash $command.sh $*
elif [ -e $command.lua ]; then
	pushd $root >/dev/null
	lua ${PROJECT+$PROJECT/}bin/$command.lua $*
	popd >/dev/null
else
	echo "Command not found: $command" 1>&2
fi;
