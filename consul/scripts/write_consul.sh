#!/usr/bin/env bash

set -e
echo "[INFO] -- Starting $0 $@"

CONSUL_URL=$1
SERVICE=$2
ENV_FILE=$3

while [[ $(curl -s -X PUT 'alive' ${CONSUL_URL}/v1/kv/${SERVICE}/test) != 'true' ]]; do
  echo consul server is not ready
  sleep 1
done

# Load environment variables
while read line; do
  echo "[INFO] -- Reading line: $line"
  CONSUL_KEY=$(echo $line | sed 's/^export //' | awk -F"=" '{print $1}')
  # Can be '=' in the value
  CONSUL_VALUE=$(echo $line | sed 's/^export //' | sed s/$CONSUL_KEY\=//)
  echo "[INFO] -- Getting key: $CONSUL_KEY and value: $CONSUL_VALUE."
  curl -X PUT -d "$CONSUL_VALUE" ${CONSUL_URL}/v1/kv/${SERVICE}/$CONSUL_KEY 1>/dev/null
done < $ENV_FILE 2>/dev/null

