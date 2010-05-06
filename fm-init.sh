PROJECT=$1

mkdir -p $PROJECT/bin
source fm-load-settings.sh >$PROJECT/settings
echo "PROJECT='$PROJECT'" >.fm
