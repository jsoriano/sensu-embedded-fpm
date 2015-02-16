#!/bin/bash

[ "$1" ] || {
	echo "
$0 GEM_PACKAGE1 [GEM_PACKAGE2 [...]] [-- DEB_DEPENDENCY [...]]

Examples:
	$0 mysql -- libmysqlclient-dev
	$0 inifile
	$0 mysql inifile -- libmysqlclient-dev
"
	exit 1
}

mkdir -p $PWD/out

docker build -t sensu-fpm .
docker run -i -t -v $PWD/out:/out sensu-fpm "$@"
