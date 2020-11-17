FROM	debian:buster

LABEL	maintainer="danrodri@student.42madrid.com"

ENV		AIENV on

WORKDIR	/tmp/

COPY	srcs/*.sql /tmp/
	
COPY	srcs/localhost.conf /tmp/

RUN 	apt-get update && apt-get install -y \
		default-mysql-server \
		nginx \
		openssl \
		php7.3-fpm \
		php7.3-json \
		php7.3-mysql \
		php7.3-mbstring \
		wget \
	&&	rm -rf /var/lib/apt/lists/* \
	&&	mkdir /var/www/localhost \
	&&	mv /tmp/localhost.conf /etc/nginx/sites-available/ \
	&&	ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled/localhost.conf \
	&&	wget https://wordpress.org/latest.tar.gz \
	&&	tar xfz latest.tar.gz \
	&&	rm wordpress/wp-config-sample.php \
	&&	mv wordpress /var/www/localhost \
	&&	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&&	tar xfz phpMyAdmin-5.0.4-all-languages.tar.gz \
	&&	mv phpMyAdmin-5.0.4-all-languages /usr/share/phpmyadmin \
	&&	ln -s /usr/share/phpmyadmin /var/www/localhost/  \
	&&	chown -R www-data:www-data /usr/share/phpmyadmin \
	&&	chown -R www-data:www-data /var/www/ \
	&&	chmod -R 755 /var/www \
	&&	chmod -R 755 /usr/share/phpmyadmin \
	&&	service mysql start \
	&&	mysql -u root < /tmp/db-commands.sql \ 
	&&	mysql -u root < /tmp/wp_database.sql \
	&&	mysql -u root < /usr/share/phpmyadmin/sql/create_tables.sql \
	&&	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt \
		-subj "/C=42/ST=42/L=42/O=ft_server/OU=no"

COPY	--chown=www-data:www-data srcs/index.html /var/www/localhost/

COPY	--chown=www-data:www-data srcs/wp-config.php /var/www/localhost/wordpress/

COPY	--chown=www-data:www-data srcs/config.inc.php /usr/share/phpmyadmin/

COPY	srcs/start_server.sh /

EXPOSE	80

EXPOSE	443

CMD		["/start_server.sh"]
