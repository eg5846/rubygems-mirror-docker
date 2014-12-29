FROM eg5846/ubuntu-docker:trusty 
MAINTAINER Andreas Egner <andreas.egner@web.de>

ENV HOME /root

# Update system and install packages
RUN \
  apt-get update && \
  apt-get dist-upgrade -y && \
  apt-get install -y --no-install-recommends git rake ruby ruby-hoe ruby-net-http-persistent && \
  apt-get autoremove -y && \
  apt-get clean

# Install and configure rubygems-mirror
RUN \
  git clone https://github.com/huacnlee/rubygems-mirror.git && \
  mkdir -p /mirror/rubygems.org && \
  mkdir /root/.gem
ADD mirrorrc /root/.gem/.mirrorrc

# Install run.sh
ADD run.sh /run.sh
RUN chmod 0755 /run.sh

VOLUME ["/mirror/rubygems.org"]

CMD ["/run.sh"]
