FROM centos:centos7
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD . /usr/local/nps
RUN chmod +x /usr/local/nps/np-stack && \
    ln -s /usr/local/nps/np-stack /usr/bin/nps && \
    nps setup

EXPOSE 80 443
ENTRYPOINT ["/bin/bash"]
CMD ["nps","start", "0"]