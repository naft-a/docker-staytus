Supports Internationalization (I18n):
 - add file with locale identifier as a name to content/locales:
 - `touch content/locales/bg.yml`
 - add needed definitions then inside the themes add: `t('themes.default.hello', locale: :bg)`

Docker without docker-compose:

# Run mariadb container with a volume
`docker run --name mariadb -v /home/ganch/save/:/var/lib/mysql -e MYSQL_USER=staytus -e MYSQL_PASSWORD=staytus -e MYSQL_DATABASE=staytus -e MYSQL_ROOT_PASSWORD=password -d mariadb:latest`

# Run staytus container
`docker run -it --link mariadb:db -p 8787:8787 -e DB_ADAPTER=mysql2 -e DB_HOST=db -e DB_POOL=5 -e DB_USER=staytus -e DB_PASSWORD=staytus -e DB_DATABASE=staytus georgiganchev/staytus:latest`
