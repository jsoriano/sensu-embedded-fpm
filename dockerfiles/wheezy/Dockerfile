FROM debian:wheezy

RUN apt-get update && \
	apt-get install -y wget && \
	wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | apt-key add - && \
	echo "deb http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list && \
	apt-get update && \
	apt-get install -y sensu && \
	apt-get install -y build-essential && \
	apt-get install -y ruby rubygems ruby-dev && \
	apt-get clean

RUN gem install fpm --no-ri --no-rdoc
ADD fpm_build.sh /fpm_build.sh

ENTRYPOINT ["/fpm_build.sh"]
