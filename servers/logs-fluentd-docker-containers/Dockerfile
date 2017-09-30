FROM ubuntu:16.04

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            ca-certificates \
            ruby \
            wget telnet nano zip unzip iputils-ping \
 && buildDeps=" \
      make gcc g++ libc-dev \
      ruby-dev \
      wget bzip2 \
    " \
 && apt-get install -y --no-install-recommends $buildDeps \
 && update-ca-certificates

 # gem install
RUN echo 'gem: --no-document' >> /etc/gemrc \
 && gem install oj \
 && gem install json \
 && gem install fluentd -v 0.12.34
RUN apt-get install -y git
#RUN gem install specific_install \
# && gem specific_install -l https://github.com/elvisgiv/fluent-plugin-mysql-replicator
RUN gem install fluent-plugin-parser
RUN gem install fluent-plugin-elasticsearch
RUN gem install fluent-plugin-kafka
RUN gem install fluent-plugin-record-reformer

RUN wget -O /tmp/jemalloc-4.4.0.tar.bz2 https://github.com/jemalloc/jemalloc/releases/download/4.4.0/jemalloc-4.4.0.tar.bz2 \
 && cd /tmp && tar -xjf jemalloc-4.4.0.tar.bz2 && cd jemalloc-4.4.0/ \
 && ./configure && make \
 && mv lib/libjemalloc.so.2 /usr/lib

 # purge
RUN apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

RUN useradd fluent -d /home/fluent -m -U
RUN chown -R fluent:fluent /home/fluent

# for log storage (maybe shared with host)
RUN mkdir -p /fluentd/log
# configuration/plugins path (default: copied from .)
RUN mkdir -p /fluentd/etc /fluentd/plugins
COPY files/json_in_string.rb /fluentd/plugins

RUN chown -R fluent:fluent /fluentd


### bootstrap script
COPY files/bootstrap /etc/
RUN chmod +x /etc/bootstrap
RUN mkdir -p /opt/bootstrap/

#USER fluent
WORKDIR /home/fluent

# Tell ruby to install packages as user
RUN echo "gem: --user-install --no-document" >> ~/.gemrc
ENV PATH /home/fluent/.gem/ruby/2.3.0/bin:$PATH
ENV GEM_PATH /home/fluent/.gem/ruby/2.3.0:$GEM_PATH

COPY files/fluentd/fluent.conf /fluentd/etc/


ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2"

#EXPOSE 24224 5140

#CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT


