#!/usr/bin/env bash

set -e
echo "[INFO] -- Starting: $0 at $(date)"

CONSUL_URL=$1
SERVICE=$2
FILE=$3

while [[ $(curl -s -X PUT 'alive' ${CONSUL_URL}/v1/kv/${SERVICE}/test) != 'true' ]]; do
  echo consul server is not ready
  sleep 1
done

curl -s -X PUT --data-binary @${FILE} ${CONSUL_URL}/v1/kv/ops/${SERVICE}/local_php >/dev/null || echo "[WARN] - $(date) - No ${FILE} found."

echo "[INFO] -- Finished: $0 at $(date)"

