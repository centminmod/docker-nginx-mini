function nps_setup() {

	# ------------------------
	# REPOS
	# ------------------------
	
	## NGINX
	cat $nps/conf/yum/nginx.repo > /etc/yum.repos.d/nginx.repo
	
	## EPEL
	# rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
	yum -y install epel-release
	
	## REMI
	rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
	
	# ------------------------
	# INSTALL
	# ------------------------
	
	## Dependecies
	yum install -y nano which hostname bc wget zip python-setuptools bash-completion mlocate

	## NGINX + MariaDB Client
	yum install -y nginx mariadb
	               
	## PHP
	yum install -y --enablerepo=remi,remi-php56 \
	               php-fpm \
	               php-common \
	               php-opcache \
	               php-pecl-apcu \
	               php-cli \
	               php-pear \
	               php-pdo \
	               php-mysqlnd \
	               php-pgsql \
	               php-pecl-mongo \
	               php-pecl-sqlite \
	               php-pecl-memcache \
	               php-pecl-memcached \
	               php-gd php-mbstring \
	               php-mcrypt php-xml

	## Cleanup Docker Image size
	yum -y update
	yum clean all
	rm -rf /var/cache/*
	               
	## Supervisor
	easy_install supervisor
	easy_install supervisor-stdout
	
	## WP-CLI
	wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	cp -a /usr/local/bin/wp /usr/bin/wp
	chmod +x /usr/local/bin/wp
	
	## JQ 
	wget -O /usr/local/bin/jq http://stedolan.github.io/jq/download/linux64/jq
	chmod +x /usr/local/bin/jq
	
	# ------------------------
	# CONFIG
	# ------------------------

	mkdir -p /app/html
	mkdir -p /app/ssl
	mkdir -p /var/cache/nginx/
	mkdir -p /var/cache/nginx/client_temp
	touch /var/log/php-fpm/www-php.error.log
	chmod 0666 /var/log/php-fpm/www-php.error.log
			
	cat $nps/conf/supervisor/supervisord.conf > /etc/supervisord.conf
	cat $nps/conf/nginx/default.conf > /etc/nginx/conf.d/default.conf
	cat $nps/conf/nginx/defaultssl.conf > /etc/nginx/conf.d/defaultssl.conf
	cat $nps/conf/php/php-fpm.conf > /etc/php-fpm.d/www.conf
	cat $nps/conf/nginx/nginx.conf > /etc/nginx/nginx.conf
	cat $nps/conf/nginx/fastcgi_params > /etc/nginx/fastcgi_params
	cat $nps/conf/html/index.html > /app/html/index.html
	\cp -f $nps/conf/html/cmlogo.png /app/html/
	cat $nps/conf/html/info.php > /app/html/info.php

	PHPINICUSTOM='/etc/php.d/00_customphp.ini'
	CURLINICUSTOM='/etc/php.d/00_curlcainfo.ini'

	touch $PHPINICUSTOM
	touch $CURLINICUSTOM

    echo "max_execution_time = 60" >> ${PHPINICUSTOM}
    echo "short_open_tag = On" >> ${PHPINICUSTOM}
    echo "realpath_cache_size = 8192k" >> ${PHPINICUSTOM}
    echo "realpath_cache_ttl = 600" >> ${PHPINICUSTOM}
    echo "upload_max_filesize = 20M" >> ${PHPINICUSTOM}
    echo "memory_limit = 128M" >> ${PHPINICUSTOM}
    echo "post_max_size = 20M" >> ${PHPINICUSTOM}
    echo "expose_php = Off" >> ${PHPINICUSTOM}
    echo "mail.add_x_header = Off" >> ${PHPINICUSTOM}
    echo "max_input_nesting_level = 128" >> ${PHPINICUSTOM}
    echo "max_input_vars = 4000" >> ${PHPINICUSTOM}
    echo "mysqlnd.net_cmd_buffer_size = 16384" >> ${PHPINICUSTOM}

    if [[ "$(date +"%Z")" = 'EST' ]]; then
        echo "date.timezone = Australia/Brisbane" >> ${PHPINICUSTOM}
    else
        echo "date.timezone = UTC" >> ${PHPINICUSTOM}
    fi

    if [ ! -f /etc/ssl/certs/cacert.pem ]; then
        wget -q -O /etc/ssl/certs/cacert.pem http://curl.haxx.se/ca/cacert.pem
        echo "curl.cainfo = '/etc/ssl/certs/cacert.pem'" > ${CURLINICUSTOM}
    else
        wget -q -O /etc/ssl/certs/cacert.pem http://curl.haxx.se/ca/cacert.pem
        echo "curl.cainfo = '/etc/ssl/certs/cacert.pem'" > ${CURLINICUSTOM}
    fi

	# ------------------------
	# SSL CERT.
	# ------------------------
	
	cd /app/ssl
	
	cat $nps/conf/nginx/openssl.conf > openssl.conf
	sed -i "s/EHOSTNAME/$(hostname)/" openssl.conf
	openssl req -nodes -sha256 -newkey rsa:2048 -keyout app.key -out app.csr -config openssl.conf -batch
	openssl rsa -in app.key -out app.key
	openssl x509 -req -days 365 -sha256 -in app.csr -signkey app.key -out app.crt	
	rm -f openssl.conf
	
}
