#!/bin/bash

set -e

TARGETS=""
DEB_DEPENDENCIES=""
RUBY_DEPENDENCIES=""

while getopts "d:g:" dep; do
    case $dep in
        d)
            DEB_DEPENDENCIES="$DEB_DEPENDENCIES $OPTARG"
            ;;
        g)
            RUBY_DEPENDENCIES="$RUBY_DEPENDENCIES $OPTARG"
            ;;
        :)
            echo "OPTION -$OPTARG requires an argument"
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))
TARGETS="$@"

echo Building Sensu gems for: $TARGETS


EMBEDDED_PATH=/opt/sensu/embedded/bin
GEM=$EMBEDDED_PATH/gem
PATH=$PATH:$(gem environ gemdir)/bin
FPM=$(which fpm)

PREFIX=sensu-gem
OPTIONS="--gem-gem $GEM --gem-package-name-prefix=$PREFIX"

EXCLUDED_DEPENDENCIES=$(/opt/sensu/embedded/bin/gem list --no-versions)

for dependency in $EXCLUDED_DEPENDENCIES; do
	OPTIONS="$OPTIONS --gem-disable-dependency $dependency"
done

if [ $DEBIAN_DEPENDENCIES ]; then
	apt-get update
	apt-get install -y --force-yes $DEBIAN_DEPENDENCIES
fi

for DGEM in $RUBY_DEPENDENCIES; do
    read GEM_NAME GEM_VERSION <<< $( echo $DGEM | tr "," " ")
    if [ $GEM_VERSION ]; then
        GEM_VERSION_PARAM="-v $GEM_VERSION"
    else
        GEM_VERSION_PARAM=''
    fi
    $GEM install --no-ri --no-rdoc --install-dir /tmp/gems $GEM_NAME $GEM_VERSION_PARAM
done

$GEM install --no-ri --no-rdoc --install-dir /tmp/gems $TARGETS

set +e
find /tmp/gems -name *.gem -exec $FPM -p /out -d sensu -s gem -t deb $OPTIONS {}  \;
