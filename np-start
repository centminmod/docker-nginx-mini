#!/usr/bin/env bash

if [[  ! -f '/var/log/nginx.log'  ]]; then touch /var/log/nginx.log; fi
if [[  ! -f '/var/log/php-fpm.log'  ]]; then touch /var/log/php-fpm.log; fi

/usr/bin/supervisord -n -c /etc/supervisord.conf