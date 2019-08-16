FROM php:7.2-cli

# install tools
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y unzip git nano \
    && apt-get install -y nodejs npm


# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

# install serverless
RUN npm install -g serverless

COPY ./docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]