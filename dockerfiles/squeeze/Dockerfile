FROM debian:squeeze

ADD dockerfiles/squeeze/sources.list /etc/apt/sources.list

RUN apt-get -o Acquire::Check-Valid-Until=false update
RUN apt-get install -y wget
RUN wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | apt-key add -
RUN echo "deb http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list
RUN apt-get -o Acquire::Check-Valid-Until=false update
RUN apt-get install -y sensu
RUN apt-get install -y build-essential
RUN apt-get install -y ruby rubygems
RUN gem install fpm -v 1.3.3 --no-ri --no-rdoc
ADD fpm_build.sh /fpm_build.sh

ENTRYPOINT ["/fpm_build.sh"]
