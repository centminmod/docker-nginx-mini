FROM centos:centos7
MAINTAINER "Tropicloud" <admin@tropicloud.net>

ADD conf /etc/np-stack/
RUN cat /etc/np-stack/yum/nginx.repo > /etc/yum.repos.d/nginx.repo; \
    rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm; \
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm; \
    yum install -y nginx mariadb; \
    yum install -y php-fpm php-common php-opcache php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongo php-pecl-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml --enablerepo=remi,remi-php56

RUN cat /etc/np-stack/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf; \
    cat /etc/np-stack/nginx/nginx.conf > /etc/nginx/nginx.conf; \
    cat /etc/np-stack/php/php-fpm.conf > /etc/php-fpm.d/www.conf; \
    cat /etc/np-stack/html/index.html > /usr/share/nginx/html/index.html; \
    cat /etc/np-stack/html/info.php > /usr/share/nginx/html/info.php;

RUN mkdir -p /usr/share/nginx/ssl && cd /usr/share/nginx/ssl; \
    openssl req -nodes -sha256 -newkey rsa:2048 -keyout localhost.key -out localhost.csr -config /etc/np-stack/nginx/openssl.conf -batch; \
    openssl rsa -in localhost.key -out localhost.key; \
    openssl x509 -req -days 365 -in localhost.csr -signkey localhost.key -out localhost.crt;

EXPOSE 80 443
CMD ["/usr/sbin/init"]
