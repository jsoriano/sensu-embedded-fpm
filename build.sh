#!/bin/bash

DISTRIBUTIONS=${DISTRIBUTIONS-$(ls dockerfiles | tr '\n' ' ')}

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

echo "Building for: $DISTRIBUTIONS"

set -e
for distribution in $DISTRIBUTIONS; do
	docker build -f dockerfiles/$distribution/Dockerfile -t sensu-fpm:$distribution .

	mkdir -p $PWD/out/$distribution
	docker run -it --rm -v $PWD/out/$distribution:/out sensu-fpm:$distribution "$@"
done
