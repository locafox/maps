FROM ubuntu:14.04
MAINTAINER Xavier Bruguera <xavier.bruguera@locafox.de>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      apache2 \
      autoconf \
      autoconf-archive \
      automake \
      bc \
      build-essential \
      curl \
      g++ \
      gcc \
      git \
      jq \
      libboost-dev \
      libboost-filesystem-dev \
      libboost-system-dev \
      libboost-thread-dev \
      libbz2-dev \
      libgeos++-dev \
      libgeos-c1 \
      libgeos-dev \
      libpq-dev \
      libproj-dev \
      libprotobuf-c0-dev \
      libtool \
      libxml2-dev \
      make \
      osmosis \
      php-db \
      php-pear \
      php5 \
      php5-json \
      php5-pgsql \
      postgresql \
      postgis \
      postgresql-contrib \
      postgresql-9.3-postgis-2.1 \
      postgresql-server-dev-9.3 \
      proj-bin \
      protobuf-c-compiler \
      sudo \
      wget && \
    pear install DB && \
    mkdir -p /app/nominatim && \
    cd /app/nominatim && \
    wget http://www.nominatim.org/release/Nominatim-2.4.0.tar.bz2 && \
    tar --strip-components=1 -xvf Nominatim-2.4.0.tar.bz2 && \
    rm  Nominatim-2.4.0.tar.bz2 && \
    ./configure && \
    make && \
    apt-get remove -y \
      autoconf \
      autoconf-archive \
      automake \
      bc \
      g++ \
      gcc \
      git \
      libboost-dev \
      libboost-filesystem-dev \
      libboost-system-dev \
      libboost-thread-dev \
      libbz2-dev \
      libproj-dev \
      libprotobuf-c0-dev \
      libxml2-dev \
      protobuf-c-compiler && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/*

## Configure postgresql
EXPOSE 5432
RUN echo "host all  all    0.0.0.0/0  trust" >> /etc/postgresql/9.3/main/pg_hba.conf && \
    echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf 
    #service postgresql start && \
    #pg_dropcluster --stop 9.3 main && \
    #pg_createcluster --start -e UTF-8 9.3 main && \
    #sudo -u postgres psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='nominatim'" | grep -q 1 || sudo -u postgres createuser -s nominatim && \
    #sudo -u postgres psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='www-data'" | grep -q 1 || sudo -u postgres createuser -SDR www-data && \
    #sudo -u postgres psql postgres -c "DROP DATABASE IF EXISTS nominatim"

ADD devops/400-nominatim.conf /etc/apache2/sites-available/400-nominatim.conf
ADD devops/httpd.conf /etc/apache2/
RUN service apache2 start && \
    a2ensite 400-nominatim.conf && \
    /etc/init.d/apache2 reload

# Expose the HTTP port
EXPOSE 8080

# Add config file and scripts to get variables from consul
ADD config/env.conf /tmp/env.conf
ADD devops/scripts /tmp

WORKDIR /app/nominatim
ADD devops/import_nominatim.sh /app/nominatim/import_nominatim.sh
RUN chmod +x ./import_nominatim.sh
ADD devops/configPostgresql.sh /app/nominatim/configPostgresql.sh
RUN chmod +x ./configPostgresql.sh
ADD devops/start.sh /app/nominatim/start.sh
RUN chmod +x /app/nominatim/start.sh
CMD /app/nominatim/start.sh

