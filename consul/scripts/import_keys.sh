#!/bin/bash

set -e
echo "[INFO] -- Starting: $0 at $(date)"

source /tmp/env.conf || echo "[WARN] -- No local setting found."

if [[ "${CONSUL_URL}x" == "x" ]]; then
    echo '[ERROR] -- We need CONSUL_URL defined in environment.'
    exit 1
fi

if [[ "${SERVICE}x" == "x" ]]; then
    echo '[ERROR] -- We need SERVICE defined in environment.'
    exit 2
fi

bash /tmp/write_consul.sh ${CONSUL_URL} ${SERVICE} /tmp/env.conf
bash /tmp/write_consul_a_file.sh ${CONSUL_URL} ${SERVICE} /tmp/local_php

echo "[INFO] -- Finished: $0 at $(date)"

