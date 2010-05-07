PROJECT=$1

echo $PROJECT >.current-project
mkdir -p $PROJECT/bin
source fm-load-settings.sh >$PROJECT/settings
