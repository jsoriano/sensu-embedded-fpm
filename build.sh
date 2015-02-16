#!/bin/bash

[ "$1" ] || {
	echo "
$0 GEM_PACKAGE [-- DEB_DEPENDENCIES ]

Examples:
	$0 mysql -- libmysqlclient-dev
	$0 inifile
"
	exit 1
}

mkdir -p $PWD/out

docker build -t sensu-fpm .
docker run -i -t -v $PWD/out:/out sensu-fpm "$@"
