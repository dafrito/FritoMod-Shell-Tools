source fm-load-settings.sh >/dev/null

NAME=$1
aux=$2

if [ $PROJECT ]; then
	COMPONENT=$PROJECT"_"$NAME
else
	COMPONENT=$NAME
fi;

if [ $aux ]; then
	path=$COMPONENT"_"$aux
else
	path=$COMPONENT
fi

echo "# Interface: $INTERFACE"
if [ $PROJECT ]; then
	title="# Title: $PROJECT: $NAME"
else
	title="# Title: $NAME"
fi

if [ $aux ]; then
	echo "$title - $aux"
else
	echo $title
fi;

echo "# Author: $AUTHOR"
echo "# Version: $VERSION"

find $path -name "*.lua" | xargs fm-requires.lua $path
