FROM php:7.2-fpm

COPY moodledev.ini /usr/local/etc/php/conf.d/

RUN  apt-get update \
	&& apt-get install -y libpq-dev \
	&& docker-php-ext-install pgsql \
	&& apt-get install -y locales

# Set the locale
RUN locale-gen en_AU.UTF-8
RUN localedef -i en_AU -f UTF-8 en_AU.UTF-8
ENV LANG en_AU.UTF-8  
ENV LANGUAGE en_AU:en  
ENV LC_ALL en_AU.UTF-8 
RUN update-locale

RUN apt-get install -y libzip-dev \
	&& docker-php-ext-install zip

RUN apt-get install -y \
	    libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install gd

RUN apt-get install -y \
		libxml2-dev \
	&& docker-php-ext-install xmlrpc soap

RUN apt-get install -y \
		libicu-dev \
	&& docker-php-ext-install intl

RUN yes | pecl install xdebug \
	&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# Enable debugging of CLI scripts with IntelliJ (Hostname must match server name at ‘Project Settings | PHP | Servers’).
ENV PHP_IDE_CONFIG serverName=localhost

RUN apt-get install -y \
	ssmtp \
	netcat

# modify ssmtp settings 
RUN sed -ri -e 's/^(mailhub=).*/\1smtp-server/' \  
    -e 's/^#(FromLineOverride)/\1/' /etc/ssmtp/ssmtp.conf

WORKDIR /var/www
