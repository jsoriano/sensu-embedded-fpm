FROM debian:jessie

RUN apt-get update && \
	apt-get install -y wget apt-transport-https && \
	wget -q https://sensu.global.ssl.fastly.net/apt/pubkey.gpg -O- | apt-key add - && \
	echo "deb https://sensu.global.ssl.fastly.net/apt jessie main" > /etc/apt/sources.list.d/sensu.list && \
	apt-get update && \
	apt-get install -y sensu && \
	apt-get install -y build-essential && \
	apt-get install -y ruby rubygems ruby-dev && \
	apt-get clean

RUN gem install fpm --no-ri --no-rdoc
ADD fpm_build.sh /fpm_build.sh

ENTRYPOINT ["/fpm_build.sh"]
