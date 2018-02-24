#!/bin/bash
set -e

if [ "${1}" == "" ]; then
  echo "define api token"
  exit 1
fi

TOKEN="${1}"

for i in 1 2 3; do
  scalet=$(curl -s 'https://api.vscale.io/v1/scalets' -H "X-Token: ${TOKEN}" | python3 -c "import sys, json; print(json.load(sys.stdin)[0]['ctid'])")
  curl "https://api.vscale.io/v1/scalets/${scalet}" -X DELETE  -H "X-Token: ${TOKEN}" -H 'Content-Type: application/json;charset=UTF-8'
  sleep 10
done