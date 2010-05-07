#!/bin/bash
PATH=/bin:/usr/bin:$HOME/bin:${0%/*}

source fm-library.sh
source fm-load-settings.sh >/dev/null

if [ $1 ]; then
	save_toc $1 $2
	exit
fi

[ $PROJECT ] || error "No project defined"

for comp in `find * -maxdepth 0 -name $PROJECT"_*" -type d | egrep "_.*$" -o | trim 2`
do
	if echo $comp | grep -q "_Tests$"; then
		comp=${comp%_*}
		aux="Tests"
	else
		unset aux
	fi
	save_toc $comp $aux
done
save_toc $PROJECT
