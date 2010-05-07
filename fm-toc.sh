source fm-load-settings.sh >/dev/null

make_path $1 $2
make_title $1 $2

echo "## Interface: $INTERFACE"
echo "## Title: $title"
echo "## Author: $AUTHOR"
echo "## Version: $VERSION"

find $path -name "*.lua" | xargs fm-requires.lua $path
