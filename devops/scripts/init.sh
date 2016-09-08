#!/bin/bash

set -e
echo "[INFO] -- Starting: $0 at $(date)"

# Getting initial variables
source /tmp/env.conf || echo "[WARN] -- No local setting found."

# Checking Consul URL is not empty
if [[ "${CONSUL_URL}x" == "x" ]]; then
    echo '[ERROR] -- We need CONSUL_URL defined in the env.conf file.'
    exit 1
fi

# Checking Service variable is not empty
if [[ "${SERVICE}x" == "x" ]]; then
    echo '[ERROR] -- We need SERVICE defined in the env.conf file.'
    exit 1
fi

# Read variables from consul
echo "[INFO] - $(date) - Reading info from ${SERVICE} in consul: ${CONSUL_URL}."
bash /tmp/read_consul.sh ${CONSUL_URL} ${SERVICE} | grep '^export ' > /tmp/consul_env.conf

