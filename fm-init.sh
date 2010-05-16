#!/bin/bash

mkdir -p .fm/$1
if [ ! -e .fm/settings ]; then
	source fm-load-settings.sh >.fm/settings
fi
