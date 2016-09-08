#!/bin/bash

set -e
echo "[INFO] -- Starting: $0 at $(date)"

# Getting initial variables
source /tmp/consul_env.conf

curl -s "${CONSUL_URL}/v1/kv/ops/${SERVICE}/local_php?raw" >> /app/nominatim/settings/local.php

service postgresql status
pg_dropcluster --stop 9.3 main
pg_createcluster --start -e UTF-8 9.3 main
sudo -u postgres psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='nominatim'" | grep -q 1 || sudo -u postgres createuser -s nominatim
sudo -u postgres psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='www-data'" | grep -q 1 || sudo -u postgres createuser -SDR www-data
sudo -u postgres psql postgres -c "DROP DATABASE IF EXISTS nominatim"
cd /app/nominatim
useradd -m -p ${NOMINATIM_USER_PASSWORD} nominatim || echo "[WARN] - $(date) - Cannot create user nominatim, maybe already exists."
wget --output-document=/app/data.pbf ${OPENSTREETMAP_MAP_FILE_URL}
sudo -u nominatim ./utils/setup.php --osm-file /app/data.pbf --all --threads 2 --osm2pgsql-cache 18000
mkdir -p /var/www/nominatim
cat ./settings/local.php
./utils/setup.php --create-website /var/www/nominatim
echo "[INFO] -- Finished: $0 at $(date)"

