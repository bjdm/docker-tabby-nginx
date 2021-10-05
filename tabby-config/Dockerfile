# Copy tabby and configurations
#Author: Brent Mackey
#Purpose: Tabby webapp with nginx

FROM tabby:tabby-base

COPY config/supervisor/supervisord.conf /etc/supervisord.conf
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/msmtp/msmtp.conf /etc/msmtprc
COPY config/nginx/tabby.conf /etc/nginx/sites-available/tabby.conf
COPY config/nginx/conf.d/ /etc/nginx/conf.d/
COPY config/php7/ /etc/php7/
COPY config/php7/ /etc/php/
COPY config/php7/php.ini /usr/local/etc/php/php.ini

# Setup logging
RUN ln -sf /dev/stdout /var/log/fpm-access.log && \
    ln -sf /dev/stderr /var/log/fpm-php.www.log && \
    ln -s /etc/nginx/sites-available/tabby.conf /etc/nginx/sites-enabled/tabby.conf

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
