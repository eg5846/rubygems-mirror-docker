FROM ubuntu:trusty
MAINTAINER Andreas Egner <andreas.egner@web.de>

ENV HOME /root

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install git rake ruby ruby-hoe ruby-net-http-persistent tree && apt-get clean

# Install rubygems-mirror
RUN git clone https://github.com/huacnlee/rubygems-mirror.git

# Configure rubygems-mirror
RUN mkdir -p /mirror/rubygems.org
RUN mkdir /root/.gem
ADD mirrorrc /root/.gem/.mirrorrc

# Install run.sh
ADD run.sh /run.sh
RUN chmod 0755 /run.sh

VOLUME ["/mirror/rubygems.org"]

CMD ["/run.sh"]
