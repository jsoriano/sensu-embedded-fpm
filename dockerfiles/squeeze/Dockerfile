FROM debian:squeeze

ADD dockerfiles/squeeze/sources.list /etc/apt/sources.list
RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99-ignore-valid-until
RUN echo 'APT::Get::AllowUnauthenticated "true";' > /etc/apt/apt.conf.d/99-allow-unauthenticated

RUN apt-get update && \
	apt-get install -y wget apt-transport-https && \
	echo "deb https://sensu.global.ssl.fastly.net/apt sensu main" > /etc/apt/sources.list.d/sensu.list && \
	apt-get update && \
	# 0.22.1-1 seems to be the last version to work on squeeze
	apt-get install -y sensu=0.22.1-1 && \
	apt-get install -y build-essential && \
	apt-get install -y ruby rubygems ruby-dev && \
	apt-get clean

RUN gem install json -v 1.8.3 --no-ri --no-rdoc
RUN gem install fpm -v 1.3.3 --no-ri --no-rdoc
ADD fpm_build.sh /fpm_build.sh

ENTRYPOINT ["/fpm_build.sh"]
