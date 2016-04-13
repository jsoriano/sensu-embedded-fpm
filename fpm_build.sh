#!/bin/bash

set -e

TARGETS=""

while [ "$1" ] && [ "$1" != "--" ]; do
	TARGETS="$TARGETS $1"
	shift
done

echo Building Sensu gems for: $TARGETS

if [ "$1" = "--" ]; then
	shift
	DEPENDENCIES=$@
fi

EMBEDDED_PATH=/opt/sensu/embedded/bin
GEM=$EMBEDDED_PATH/gem
PATH=$PATH:$(gem environ gemdir)/bin/
FPM=$(which fpm)

PREFIX=sensu-gem
OPTIONS="--gem-gem $GEM --gem-package-name-prefix=$PREFIX"

EXCLUDED_DEPENDENCIES=$(/opt/sensu/embedded/bin/gem list --no-versions)

for dependency in $EXCLUDED_DEPENDENCIES; do
	OPTIONS="$OPTIONS --gem-disable-dependency $dependency"
done

if [ $DEPENDENCIES ]; then
	apt-get install -y --force-yes $DEPENDENCIES
fi

$GEM install --no-ri --no-rdoc --install-dir /tmp/gems $TARGETS

set +e

find /tmp/gems -name *.gem -exec $FPM -p /out -d sensu -s gem -t deb $OPTIONS {}  \;
