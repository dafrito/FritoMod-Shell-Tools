#!/bin/bash

mkdir -p .fm/$1
touch .fm/$1/settings
if [ ! -e .fm/settings ]; then
	source fm-load-settings.sh >.fm/settings
fi
