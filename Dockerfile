#Author: Brent Mackey
#Purpose: Tabby webapp with nginx

FROM php:7.4-fpm-alpine

ARG VERSION='1.0.0'


## Set up environment variables
# SSMTP
ENV SSMTP_ROOT='bjdm.92@gmail.com'

RUN apk update && apk upgrade && \
    apk add nginx supervisor tzdata msmtp bash ca-certificates postgresql-dev && \
    chown -R www-data:www-data /var/lib/nginx && \
    chown -R www-data:www-data /var/www && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    rm  -rf /tmp/* /var/cache/apk/*
#VOLUME /var/www

# Copy tabby and configurations
COPY config/supervisor/supervisord.conf /etc/supervisord.conf
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/msmtp/msmtp.conf /etc/msmtprc
COPY config/nginx/tabby.conf /etc/nginx/sites-available/tabby.conf
COPY config/nginx/conf.d/ /etc/nginx/conf.d/

# Setup logging
RUN ln -sf /dev/stdout /var/log/fpm-access.log && \
    ln -sf /dev/stderr /var/log/fpm-php.www.log
#COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
#COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

# nginx site conf
RUN mkdir -p /etc/nginx/sites-available/ && \
    mkdir -p /etc/nginx/sites-enabled/ && \
    rm -Rf /var/www/* && \
    mkdir /var/www/html/ && \
    mkdir /run/nginx/ && \
    touch /run/nginx/nginx.pid && \
    ln -s /etc/nginx/sites-available/tabby.conf /etc/nginx/sites-enabled/tabby.conf
RUN docker-php-ext-install pdo_pgsql

# Copy in tabby
COPY tabby-1.1.1 /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# PHP Configuration
ENV TIMEZONE                        Australia/Brisbane \
    PHP_FPM_USER                    www-data \
    PHP_FPM_GROUP                   www-data \
    PHP_FPM_LISTEN_MODE             0660 \
    PHP_MEMORY_LIMIT                512M \
    PHP_MAX_UPLOAD                  50M \
    PHP_MAX_FILE_UPLOAD             200 \
    PHP_MAX_POST                    100M \
    PHP_DISPLAY_ERRORS              On \
    PHP_DISPLAY_STARTUP_ERRORS      On \
    PHP_CGI_FIX_PATHINF             O

# create daily cronjob
RUN ln -s /var/www/html/cron.php /etc/periodic/daily/

EXPOSE 80

WORKDIR "/var/www/html"

CMD ["/usr/bin/supervisord"]
