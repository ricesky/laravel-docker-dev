# Base image
FROM php:8.1-apache-bullseye

ADD config/lib/libltdl.la /usr/lib/x86_64-linux-gnu/libltdl.la
# Install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    zlib1g-dev libpng-dev \
    gnupg2 \
    curl \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
    msodbcsql17 \
    unixodbc-dev \
    supervisor \
    locales \
    && pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv \
    && pecl install xdebug-3.2.0 \
    && docker-php-ext-enable --ini-name 30-xdebug.ini xdebug \
	&& docker-php-ext-install gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN chmod +x /etc/init.d/supervisor
RUN update-rc.d supervisor defaults

    # Composer install
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Enable Apache modules
RUN a2enmod rewrite

# Copy Apache virtual host configuration file
ADD config/apache/apache-virtual-hosts.conf /etc/apache2/sites-available/000-default.conf
ADD config/php/php.conf /usr/local/etc/php/php.ini

# Init
ADD init.sh /init.sh
RUN chmod 755 /*.sh

# Expose port 80
EXPOSE 80

CMD ["/init.sh"]
