#!/bin/bash
if [ "$AIENV" == "off" ]; then
	sed -i /etc/nginx/sites-available/default -e 's/autoindex on/autoindex off/'
fi
service php7.3-fpm start
service mysql start
nginx -g 'daemon off;'
tail -f /var/log/nginx/access.log
