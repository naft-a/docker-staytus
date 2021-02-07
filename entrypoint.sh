#!/bin/bash

DB_ADAPTER="${DB_ADAPTER:-mysql2}"
DB_POOL="${DB_POOL:-5}"
DB_HOST="${DB_HOST:-database}"
DB_USER="${DB_USER:-staytus}"
DB_PASSWORD="${DB_PASSWORD:-staytus}"
DB_DATABASE="${DB_DATABASE:-staytus}"

cd /opt/rails/staytus || { echo "staytus directory not found."; exit 1; }

if [[ ! -f "/opt/rails/staytus/config/database.yml" ]]; then
    cp -f /opt/rails/staytus/config/database.example.yml /opt/rails/staytus/config/database.yml
fi

echo "CREATE DATABASE staytus CHARSET utf8 COLLATE utf8_unicode_ci;" | mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" || { echo "=> Issues creating database staytus, can be ignored when the database already exists."; true; }

sed -i "s|adapter:.*|adapter: \"$DB_ADAPTER\"|" /opt/rails/staytus/config/database.yml
sed -i "s|pool:.*|pool: $DB_POOL|" /opt/rails/staytus/config/database.yml
sed -i "s|host:.*|host: \"$DB_HOST\"|" /opt/rails/staytus/config/database.yml
sed -i "s|username:.*|username: \"$DB_USER\"|" /opt/rails/staytus/config/database.yml
sed -i "s|password:.*|password: \"$DB_PASSWORD\"|" /opt/rails/staytus/config/database.yml
sed -i "s|database:.*|database: \"$DB_DATABASE\"|" /opt/rails/staytus/config/database.yml

set -ex

printenv

bundle exec rake staytus:build

if [[ ! -z ${CLEAN_INSTALL} ]]; then
    echo "=> Running new staytus installation"
    export DISABLE_DATABASE_ENVIRONMENT_CHECK=1
    export I_AM_SURE=1
    bundle exec rake staytus:install
fi

bundle exec rake staytus:upgrade

exec procodile start -f
