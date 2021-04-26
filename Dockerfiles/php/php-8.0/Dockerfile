FROM php:8.0-fpm

RUN apt-get update && \
        apt-get install -y \
        libzip-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
	libxml2-dev \
	libicu-dev \
	libpq-dev \
	locales \
	msmtp \
	netcat

RUN docker-php-ext-install pgsql

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN docker-php-ext-install zip

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install gd

RUN pecl install xmlrpc-beta && docker-php-ext-enable xmlrpc
RUN docker-php-ext-install soap

RUN docker-php-ext-install intl

RUN yes | pecl install xdebug \
	&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo 'xdebug.client_host=172.17.0.1' >> /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo 'xdebug.client_port=9000' >> /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo 'xdebug.start_upon_error=yes' >> /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo 'xdebug.log_level=0' >> /usr/local/etc/php/conf.d/xdebug.ini

# Enable debugging of CLI scripts with IntelliJ (Hostname must match server name at ‘Project Settings | PHP | Servers’).
ENV PHP_IDE_CONFIG serverName=localhost

RUN docker-php-ext-install opcache

RUN apt-get install -y \
	sassc

# Set the locale
RUN locale-gen en_AU.UTF-8
RUN localedef -i en_AU -f UTF-8 en_AU.UTF-8
ENV LANG en_AU.UTF-8  
ENV LANGUAGE en_AU:en  
ENV LC_ALL en_AU.UTF-8 
RUN update-locale

# Copy configuration files
COPY moodledev.ini /usr/local/etc/php/conf.d/
COPY msmtprc /etc/msmtprc
RUN chmod 600 /etc/msmtprc

WORKDIR /var/www
