FROM ruby:2.6 as base

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 && \
    add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirrors.coreix.net/mariadb/repo/10.1/ubuntu xenial main'

# Install main dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      nodejs \
      libmariadbclient-dev \
      mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Prepare application directory
RUN useradd -r -d /opt/rails -m -s /bin/bash rails
USER rails
RUN mkdir -p /opt/rails/staytus
WORKDIR /opt/rails/staytus

# Install app
RUN git clone https://github.com/naft-a/staytus.git /opt/rails/staytus && \
    cd /opt/rails/staytus && \
    gem install bundler -v 1.17.2 --no-doc && \
    gem install procodile && \
    gem install json && \
    bundle install --deployment --without development:test

USER root

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER rails

EXPOSE 8787

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
