# This file is part of ianseo-docker, which is distributed under
# the terms of the General Public License (GPL), version 3. See
# LICENSE.txt for details.
#
# Copyright (C) 2020 Allan Young

#
# The line below states we will base our new image on the Official PHP 7.4 
FROM php:7.4-apache

#
# Identify the maintainer of an image
LABEL maintainer="valfrid@gmail.com"

RUN apt-get update && apt-get -y install \
       libfreetype6-dev \
       libjpeg62-turbo-dev \
       libmagickwand-dev \
       libpng-dev \
       mariadb-client \
       unzip \
       vim \
       zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli

# The following is used to get the imagick php extension since
# php-imagick is not available via apt in the php docker container.
# Yes, this is another RUN command and another layer but I figured it
# would be good to present this separately, perhaps the following can
# get dropped if/when php-imagick is available via apt in the php
# container.
RUN pecl install imagick-3.4.4 \
    && docker-php-ext-enable imagick

# Drop in an assortment of configuration information and the ianseo
# release.
COPY web/ianseo.conf /etc/apache2/conf-available/
COPY web/php.ini /usr/local/etc/php/
COPY web/web_prep.sh /tmp
COPY web/phpinfo.php /tmp

RUN /tmp/web_prep.sh
