FROM centos:centos7
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD . /usr/local/nps
RUN chmod +x /usr/local/nps/np-stack && ln -s /usr/local/nps/np-stack /usr/bin/nps && nps setup
CMD ["bash","nps","start","0"]

EXPOSE 80 443
