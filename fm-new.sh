#!/bin/bash

source fm-library.sh
source fm-load-settings.sh >/dev/null

name=$1

function build_dir {
	make_path $1 $2
	mkdir -p $path
	save_toc $1 $2
}

build_dir $name
build_dir $name Tests
