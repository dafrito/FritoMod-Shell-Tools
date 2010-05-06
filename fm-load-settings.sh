if [ -e .current-project ]; then
	SETTINGS=.current-project
	source $SETTINGS
fi

INTERFACE=${INTERFACE='30300'}
PROJECT=${PROJECT-''}
AUTHOR=${AUTHOR-$USER}
VERSION=${VERSION-"Unreleased"}

if [ -e $PROJECT/settings ]; then
	SETTINGS=$PROJECT/settings
	source $SETTINGS
fi

echo "INTERFACE='$INTERFACE'"
echo "PROJECT='$PROJECT'"
echo "AUTHOR='$AUTHOR'"
echo "VERSION='$VERSION'"
