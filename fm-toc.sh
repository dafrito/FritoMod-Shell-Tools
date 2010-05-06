source fm-load-settings.sh >/dev/null

NAME=$1
aux=$2

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
