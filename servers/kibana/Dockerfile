FROM ubuntu:16.04

# add our user and group first to make sure their IDs get assigned consistently
RUN groupadd -r kibana && useradd -r -m -g kibana kibana

RUN apt-get update

RUN apt-get install -y \
		ca-certificates \
		wget telnet nano zip unzip iputils-ping \
# generating PDFs requires libfontconfig and libfreetype6
		libfontconfig \
		libfreetype6


# grab gosu for easy step-down from root
#ENV GOSU_VERSION 1.7
#RUN set -x \
	#&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	#&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	#&& export GNUPGHOME="$(mktemp -d)" \
	#&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	#&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
#	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
#	&& chmod +x /usr/local/bin/gosu \
#	&& gosu nobody true

# grab tini for signal processing and zombie killing
#ENV TINI_VERSION v0.9.0
#RUN set -x \
#	&& wget -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini" \
#	&& wget -O /usr/local/bin/tini.asc "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini.asc" \
#	&& export GNUPGHOME="$(mktemp -d)" \
	#&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 6380DC428747F6C393FEACA59A84159D7001A4E5 \
	#&& gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini \
	#&& rm -r "$GNUPGHOME" /usr/local/bin/tini.asc \
	#&& chmod +x /usr/local/bin/tini \
	#&& tini -h

RUN set -ex; \
# https://artifacts.elastic.co/GPG-KEY-elasticsearch
	key='46095ACC8548582C1A2699A9D27D666CD88E42B4'; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	gpg --export "$key" > /etc/apt/trusted.gpg.d/elastic.gpg; \
	rm -r "$GNUPGHOME"; \
	apt-key list

ENV KIBANA_MAJOR 4.5
ENV KIBANA_VERSION 4.5.1

# https://www.elastic.co/guide/en/kibana/4.4/setup.html#kibana-apt
RUN echo "deb http://packages.elastic.co/kibana/${KIBANA_MAJOR}/debian stable main" > /etc/apt/sources.list.d/kibana.list

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends kibana=$KIBANA_VERSION \
	&& chown -R kibana:kibana /opt/kibana \
	&& rm -rf /var/lib/apt/lists/*
#	\
# ensure the default configuration is useful when using --link
#	&& sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 'http://elasticsearch:9200'!" /opt/kibana/config/kibana.yml \
#	&& grep -q 'elasticsearch:9200' /opt/kibana/config/kibana.yml

RUN rm /opt/kibana/config/kibana.yml
COPY data/config/kibana.yml /opt/kibana/config/

ENV PATH /opt/kibana/bin:$PATH

COPY data/config/bootstrap /etc/
RUN chmod +x /etc/bootstrap
RUN mkdir -p /opt/bootstrap/

# rm temp
RUN rm -rf /var/lib/apt/lists/*


EXPOSE 5601


#ENTRYPOINT ["/etc/bootstrap"]
#CMD /opt/kibana/bin/kibana
