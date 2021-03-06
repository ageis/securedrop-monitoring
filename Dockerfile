FROM alpine:3.9.4
MAINTAINER Kevin M. Gallagher <kevingallagher@gmail.com>

RUN apk update
RUN apk upgrade
RUN apk --no-cache add --update privoxy tor supervisor bash
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing polipo

RUN /usr/bin/install -m 02755 -o root -g root -d /run/tor -d /var/run/tor -d /var/log/tor -d /var/lib/tor
RUN /usr/bin/install -m 02775 -o root -g root -d /run/polipo -d /var/run/polipo -d /var/log/polipo -d /var/cache/polipo
RUN /usr/bin/install -m 02775 -o privoxy -g adm -d /run/privoxy -d /var/run/privoxy -d /var/log/privoxy

ADD files/privoxy_config /etc/privoxy/config
ADD files/polipo_config /etc/polipo/config
ADD files/torrc /etc/tor/torrc

#RUN chmod 644 /etc/tor/torrc; chown debian-tor:debian-tor /etc/tor/torrc
#RUN chmod 644 /etc/polipo/config; chown proxy:proxy /etc/polipo/config
#RUN chmod 644 /etc/privoxy/config; chown privoxy:adm /etc/privoxy/config

ADD files/supervisord.conf /etc/supervisor/supervisord.conf
#RUN ansible-playbook --connection=local --limit localhost securedrop-monitoring.yml; exit 0

EXPOSE 8123 8118 9050 9051 9053
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
