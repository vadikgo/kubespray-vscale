#!/bin/bash
set -e

if [ "${1}" == "" ]; then
  echo "define api token"
  exit 1
fi

TOKEN="${1}"

[ -e kubespray/.git ] || git clone https://github.com/kubernetes-incubator/kubespray.git

cp -r inventory/vscale kubespray/inventory/

# start servers
for i in 1 2 3; do
  curl -i -X POST 'https://api.vscale.io/v1/scalets' -H 'Content-Type: application/json;charset=UTF-8' -H "X-Token: ${TOKEN}" -d '{"make_from":"centos_7_64_001_master","rplan":"large","do_start":true,"name":"node'${i}'","keys":[18823],"location":"spb0"}'
done

# wait until servers started
for i in 0 1 2; do
  while true; do
    status=$(curl -s 'https://api.vscale.io/v1/scalets' -H "X-Token: ${TOKEN}" | python3 -c "import sys, json; print(json.load(sys.stdin)[${i}]['status'])")
    [[ $status == "started" ]] && break
    sleep 1
  done
done

# get servers ip and set it in hosts.ini
for i in 0 1 2; do
  ip=$(curl -s 'https://api.vscale.io/v1/scalets' -H "X-Token: ${TOKEN}" | python3 -c "import sys, json; print(json.load(sys.stdin)[${i}]['public_address']['address'])")
  echo "sed -i -e 's/node${i}_ip/${ip}/' kubespray/inventory/vscale/hosts.ini" | sh
done
