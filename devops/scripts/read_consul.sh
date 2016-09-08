#!/usr/bin/env bash

set -e
echo "#[INFO] -- Starting $0 $@"

CONSUL_URL=$1
SERVICE=$2

while [[ ! $(curl -s ${CONSUL_URL}) ]]; do
  echo consul server is not ready
  sleep 1
done

while read line; do
  KEY=$(echo $line | grep -o '\/.*$' | awk -F"/" '{print $2}')
  if [[ -n ${KEY}  ]]; then
   echo "export ${KEY}=$(curl -s ${CONSUL_URL}/v1/kv/${line}?raw)"
  else
   echo "[WARN] -- Found key null in line: $line."
  fi
done < <(curl -s ${CONSUL_URL}/v1/kv/${SERVICE}/?recurse | jq -r '.[].Key')

