FROM php:5.6-fpm

COPY moodledev.ini /usr/local/etc/php/conf.d/

RUN  apt-get update \
	&& apt-get install -y libpq-dev \
	&& docker-php-ext-install pgsql

RUN docker-php-ext-install zip 

RUN apt-get install -y \
	    libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install gd

RUN apt-get install -y \
		libxml2-dev \
	&& docker-php-ext-install xmlrpc soap

RUN apt-get install -y \
		libicu-dev \
	&& docker-php-ext-install intl

WORKDIR /var/www
