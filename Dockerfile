FROM ubuntu:bionic
MAINTAINER Andreas Egner <andreas.egner@web.de>

#ENV http_proxy http://192.168.1.10:800/
#ENV https_proxy https://192.168.1.10:800/
ENV HOME /root

# Update system and install packages
RUN \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y --no-install-recommends git ruby && \
  apt-get autoremove -y && \
  apt-get clean

# Install ruby gems
RUN \
  /usr/bin/gem install rake --no-rdoc --no-ri && \
  /usr/bin/gem install hoe --no-rdoc --no-ri && \
  /usr/bin/gem install net-http-persistent --no-rdoc --no-ri

# Install and configure rubygems-mirror
RUN \
  git clone https://github.com/rubygems/rubygems-mirror.git && \
  mkdir -p /mirror/rubygems.org
ADD mirrorrc /root/.gem/.mirrorrc

# Install run.sh
ADD run.sh /run.sh
RUN chmod 0755 /run.sh

VOLUME ["/mirror/rubygems.org"]

CMD ["/run.sh"]
