FROM	debian:buster

LABEL	maintainer="danrodri@student.42madrid.com"

COPY	srcs/*.sql /tmp/	

ENV		AUTOINDEX on

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
	&&	rm /var/www/html/index.nginx-debian.html \
	&&	cd /tmp \
	&&	wget https://wordpress.org/latest.tar.gz \
	&&	tar xfz latest.tar.gz \
	&&	rm wordpress/wp-config-sample.php \
	&&	mv wordpress /var/www/html \
	&&	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&&	tar xfz phpMyAdmin-5.0.4-all-languages.tar.gz \
	&&	mv phpMyAdmin-5.0.4-all-languages /usr/share/phpmyadmin \
	&&	ln -s /usr/share/phpmyadmin /var/www/html/  \
	&&	chown -R www-data:www-data /usr/share/phpmyadmin \
	&&	chown -R www-data:www-data /var/www/html \
	&&	chmod -R 755 /var/www \
	&&	chmod -R 755 /usr/share/phpmyadmin \
	&&	service mysql start \
	&&	mysql -u root < /tmp/db-commands.sql \ 
	&&	mysql -u root < /tmp/wp_database.sql \
	&&	mysql -u root < /usr/share/phpmyadmin/sql/create_tables.sql \
	&&	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt \
		-subj "/C=42/ST=42/L=42/O=ft_server/OU=no"

COPY	--chown=www-data:www-data srcs/wp-config.php /var/www/html/wordpress/

COPY	srcs/default /etc/nginx/sites-available/

COPY	--chown=www-data:www-data srcs/config.inc.php /usr/share/phpmyadmin/

COPY	srcs/start_server.sh /

COPY	srcs/index.html /var/www/html/

EXPOSE	80

EXPOSE	443

CMD		/start_server.sh
