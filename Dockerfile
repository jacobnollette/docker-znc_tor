# version 1.6.1-2
# docker-version 1.11.1
FROM ubuntu:16.04
MAINTAINER Jacob Nollette "jacob@jacobnollette.com"

ENV ZNC_VERSION 1.6.5

RUN apt-get update \
    && apt-get install -y sudo wget build-essential libssl-dev libperl-dev \
               pkg-config swig3.0 libicu-dev ca-certificates \
    && mkdir -p /src \
    && cd /src \
    && wget "http://znc.in/releases/archive/znc-${ZNC_VERSION}.tar.gz" \
    && tar -zxf "znc-${ZNC_VERSION}.tar.gz" \
    && cd "znc-${ZNC_VERSION}" \
    && ./configure --disable-ipv6 \
    && make \
    && make install \
    && apt-get remove -y wget \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /src* /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN useradd znc
ADD docker-entrypoint.sh /entrypoint.sh
ADD znc.conf.default /znc.conf.default
RUN chmod 644 /znc.conf.default

RUN apt-get update \
    && apt-get install -y tor proxychains \
		&& apt-get clean \
		&& rm -rf /src* /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN sed -i -e 's/#SOCKSPort 9050/SOCKSPort 9050/g' /etc/tor/torrc

ADD         torrc /etc/tor/
RUN         chmod 644 /etc/tor/torrc
RUN         chown 0:0 /etc/tor/torrc





VOLUME /znc-data

EXPOSE 6667
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
