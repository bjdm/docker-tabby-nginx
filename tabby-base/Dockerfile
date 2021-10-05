#Author: Brent Mackey
#Purpose: Tabby webapp with nginx

FROM php:7.4-fpm-alpine

ARG VERSION='1.0.0'


## Set up environment variables
# SSMTP
ENV SSMTP_ROOT='bjdm.92@gmail.com'

RUN apk update && apk upgrade && \
    apk add nginx supervisor tzdata msmtp bash ca-certificates postgresql-dev libcurl && \
    chown -R www-data:www-data /var/lib/nginx && \
    chown -R www-data:www-data /var/www && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm  -rf /tmp/* /var/cache/apk/*
#VOLUME /var/www


# nginx site conf
RUN mkdir -p /etc/nginx/sites-available/ && \
    mkdir -p /etc/nginx/sites-enabled/ && \
    mkdir -p /etc/php7/ && \
    rm -Rf /var/www/* && \
    mkdir /var/www/html/ && \
    mkdir /run/nginx/ && \
    touch /run/nginx/nginx.pid && \
    mkdir /run/php-fpm7/ && \
    touch /run/php-fpm7/php-fpm.sock
RUN docker-php-ext-install curl pdo_pgsql

# Copy in tabby
COPY tabby-1.1.1 /var/www/html/
RUN chown -R www-data:www-data /var/www/html


# create daily cronjob
RUN ln -s /var/www/html/cron.php /etc/periodic/daily/

EXPOSE 80

WORKDIR "/var/www/html"

CMD ["/usr/bin/supervisord"]
