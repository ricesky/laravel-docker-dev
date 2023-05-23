FROM ubuntu:20.04
MAINTAINER Ali Mangsur <alie.mangsur@gmail.com>

ADD config/lib/libltdl.la /usr/lib/x86_64-linux-gnu/libltdl.la

# Add the repository to the sources.list
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update

# Packages installation
RUN apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -y gnupg2 build-essential \
      apache2 \
      php7.0 \
      php7.0-cli \
      php7.0-gd \
      php7.0-json \
      php7.0-mbstring \
      php7.0-xml \
      php7.0-xsl \
      php7.0-zip \
      php7.0-soap \
      php7.0-dev \
      php7.0-mcrypt \
      libapache2-mod-php7.0 \
      curl \
      php7.0-curl \
      php7.0-redis \
      librdkafka-dev 

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite
RUN phpenmod mcrypt

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Update the default apache site
ADD config/apache/apache-virtual-hosts.conf /etc/apache2/sites-enabled/000-default.conf
ADD config/apache/apache2.conf /etc/apache2/apache2.conf
ADD config/apache/ports.conf /etc/apache2/ports.conf
ADD config/apache/envvars /etc/apache2/envvars

# Update php.ini
ADD config/php/php.conf /etc/php/7.0/apache2/php.ini

# MSQL server driver
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN ACCEPT_EULA=Y DEBIAN_FRONTEND=noninteractive apt-get -y install msodbcsql17 unixodbc-dev php-xml php-pear 
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pecl install sqlsrv-5.3.0
RUN pecl install pdo_sqlsrv-5.3.0
RUN pecl install redis rdkafka

RUN printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.0/mods-available/sqlsrv.ini
RUN printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.0/mods-available/pdo_sqlsrv.ini
RUN printf "; priority=10\nextension=rdkafka.so\n" > /etc/php/7.0/mods-available/rdkafka.ini
RUN printf "; priority=10\nextension=redis.so\n" > /etc/php/7.0/mods-available/redis.ini
RUN phpenmod -v 7.0 sqlsrv pdo_sqlsrv rdkafka redis

# Install locales
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

RUN apt-get -y purge php8.2*
RUN apt-get -y autoclean
RUN apt-get -y autoremove
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Init
ADD init.sh /init.sh
RUN chmod 755 /*.sh

RUN rm /var/www/html/index.html
RUN service apache2 restart

RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html/

# Volume
VOLUME /var/www/html

# Ports: apache2
EXPOSE 80

CMD ["/init.sh"]

