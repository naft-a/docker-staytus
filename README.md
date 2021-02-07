# Docker Staytus

Dockerfile to build [naft-a/staytus](https://github.com/naft-a/staytus), it is based on a `ruby:2.6` image. The quickest way to get staytus up and running with a database (mariadb:latest) is using docker compose.

## Quickstart:

```
git clone git@github.com:naft-a/docker-staytus.git
cd docker-staytus/
nano .env
```

`.env` is the app's config file so we need to make some changes in there before running any containers:

1. Uncomment the `CLEAN_INSTALL=1` this will apply the db schema to the newly created mariadb database.

```
## WARNING! THIS COMMAND WILL ERASE ALL DATA
## USE FOR NEW STAYTUS INSTALLATIONS ONLY
# CLEAN_INSTALL=1
#############################################
```

2. Populate all other variables inside.

```
## Database config ##
DB_NAME=staytus
DB_USER=staytus
DB_PASSWORD=staytus

## SMTP config ##
SMTP_HOSTNAME=
SMTP_PORT=25
SMTP_USERNAME=
SMTP_PASSWORD=
```

3. Run docker compose:

```
docker-compose up
```

That's it! Docker will now pull, build and run the required containers, by default docker compose exposes the app on port 3000 so we should be able to see the app on [localhost:3000](http://localhost:3000)

## !!! IMPORTANT !!!

Make sure you comment out the `CLEAN_INSTALL=1` environment variable in the `.env` file before running new containers to avoid data loss.

---

## Alternative installation (without docker compose)

1. Run mariadb container with a volume, change `<user>` with the real user:

```
docker run --name mariadb -v /home/<username>/db_data/:/var/lib/mysql -e MYSQL_USER=staytus -e MYSQL_PASSWORD=staytus -e MYSQL_DATABASE=staytus -e MYSQL_ROOT_PASSWORD=password -d mariadb:latest
```

2. Build & run staytus container
```
cd docker-staytus/

# Build the image
docker build -t myapp/staytus:latest .

# Run a container
docker run -it --link mariadb:db -p 3000:8787 -e DB_ADAPTER=mysql2 -e DB_HOST=db -e DB_POOL=5 -e DB_USER=staytus -e DB_PASSWORD=staytus -e DB_DATABASE=staytus myapp/staytus:latest
```

## Other features

This project supports themes when built with docker compose. The default theme is located in `content/themes/default/`, if you wish to add your custom styles or scripts, simply make the changes and rebuild the container

It also supports Internationalization (I18n) 

In `content/locales/`, add file with a locale identifier:
```
touch bg.yml
```
Add all locale definitions and use the localized string in the views:

```
<%= t('themes.default.hello', locale: :bg) %>
```
