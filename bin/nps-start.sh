function nps_start() {

	if [[  ! -f '/var/log/php-fpm.log'  ]]; then touch /var/log/php-fpm.log; fi
	if [[  ! -f '/var/log/nginx.log'    ]]; then touch /var/log/nginx.log; fi
	
	/usr/bin/supervisord -n -c /etc/supervisord.conf
	
}