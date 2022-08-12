FROM php:8.1-fpm

RUN echo "Hello From Pompy"
RUN echo "========================="
RUN echo "Installing php extensions"
RUN apt update \
        && apt install -y \
            g++ \
            libicu-dev \
            libpq-dev \
            libzip-dev \
            zip \
            zlib1g-dev \
        && docker-php-ext-install \
            intl \
            opcache \
            pdo \
            pdo_pgsql \
            pgsql \
			pdo_mysql \
			mysqli  \
            exif 

RUN php -m		
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
