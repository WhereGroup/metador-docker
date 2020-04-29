FROM ubuntu:20.04

LABEL maintainer="WhereGroup GmbH<info@wheregroup.com>"
LABEL version="1.0"

ARG var_user

ENV APACHE_RUN_USER=$var_user
ENV TZ=Europe/Berlin
ENV PROJECT_PATH=/srv/metador
ENV COMPOSER_HOME=/srv/.composer
ENV BRANCH=develop

RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apache2 \
        curl \
        git \
        openssl \
        sqlite3 \
        ssh-client \
        zip \
        unzip \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        vim \
        php \
        php7.4-curl \
        php7.4-pgsql \
        php7.4-sqlite3 \
        php7.4-json \
        php7.4-intl \
        php7.4-mbstring \
        php7.4-xml \
        php7.4-cli \
        php7.4-zip \
        php7.4-gd \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -y \
    && apt-get autoremove -y \
    && a2enmod rewrite \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && curl -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/bin \
        --filename=composer \
        && mkdir -p $COMPOSER_HOME/cache \
    && git clone https://wheregroup:xQ7fZxKSx_MxzSyszkRZ@repo.wheregroup.com/metador2/metador2.git \
        -b $BRANCH $PROJECT_PATH \
    && sed -i 's/Listen 80/Listen 8000/g' /etc/apache2/ports.conf

COPY conf/metador.conf /etc/apache2/sites-enabled/
COPY conf/parameters.yml $PROJECT_PATH/app/config

RUN cd $PROJECT_PATH \
    && composer update --no-ansi --no-plugins --no-dev --no-interaction --no-progress --no-scripts --no-suggest --optimize-autoloader \
    && bin/console doctrine:database:create \
    && bin/console doctrine:schema:create \
    && bin/console metador:init:database \
    && bin/console metador:reset:superuser --password metadordemo \
    && bin/console metador:enable:plugin \
        metador_map \
        metador_dataset_profile \
        metador_service_profile \
    && bin/console doctrine:schema:update --force \
    && bin/console assets:install --symlink \
    && chown $APACHE_RUN_USER:$APACHE_RUN_USER -R ${PROJECT_PATH}

EXPOSE 8000

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
