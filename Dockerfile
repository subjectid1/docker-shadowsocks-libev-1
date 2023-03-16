FROM alpine:latest as build

RUN	cd /tmp \
	&& apk add --update \
	&& apk add alpine-sdk git wget autoconf automake libtool pcre-dev pcre asciidoc xmlto mbedtls-dev mbedtls libsodium-dev libsodium c-ares-dev c-ares linux-headers libev-dev libev \
	&& git clone https://github.com/shadowsocks/shadowsocks-libev.git \
	&& cd shadowsocks-libev \
	&& git submodule update --init --recursive \
	&& ./autogen.sh \
	&& ./configure \
	&& make \
	&& make install \
	&& rm -rf /tmp/shadowsocks-libev \
	&& apk del alpine-sdk git wget autoconf automake libtool pcre-dev asciidoc xmlto mbedtls-dev libsodium-dev c-ares-dev linux-headers libev-dev

ADD config.json /etc/shadowsocks-libev/config.json

EXPOSE 80

VOLUME ["/etc/shadowsocks-libev"]

CMD ["ss-server", "-c", "/etc/shadowsocks-libev/config.json"]

