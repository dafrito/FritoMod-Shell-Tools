PROJECT=$1

echo "PROJECT='$PROJECT'" >.fm
mkdir -p $PROJECT/bin
source fm-load-settings.sh >$PROJECT/settings
