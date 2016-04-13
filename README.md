fpm for Sensu embedded ruby
===========================

Lots of checks in the Sensu community plugins have ruby dependencies that
are not always easy to be satisfied. This can be a problem for multiple reasons:
- Production nodes use to have restrictions with the access to internet
- Nobody really wants to install build tools in production servers
- You may want to control what version of a gem is installed in your servers
- You may want to use the embedded ruby and/or don't install a system-wide one

This simple script tries to minimize these problems by offering a
straight-forward way to quickly generate debian packages from gems.

It uses docker to start a clean debian with sensu and the embedded ruby
to retrieve and build the gems with fpm.

It also builds all gem dependencies as separated debian packages.

Usage
-----

- Install docker
- `./build.sh gempackage -- dependency1 dependency2`
- e.g: `DISTRIBUTIONS=jessie ./build.sh mysql -- libmysqlclient-dev`
- You'll have the debian packages in the out directory

By default, it builds the package for all the distributions in the dockerfiles
directory set `DISTRIBUTIONS` environment variable to the space-separated list of
distributuions you want to build for.

Or use directly the [pre-built dockers](https://hub.docker.com/r/jsoriano/sensu-fpm/)
