#!/usr/bin/env python3

import requests
import sys
import time
import os

if len(sys.argv) != 2:
    print("define api token")
    sys.exit(1)

token = sys.argv[1]
headers = {"Content-Type": "application/json;charset=UTF-8", "X-Token": token}

if not os.path.exists("kubespray/.git"):
    print("Clone kubespray repo")
    os.system("git clone https://github.com/kubernetes-incubator/kubespray.git")

print("Copy inventory...")
os.system("cp -rf inventory/vscale kubespray/inventory/")

def get_scalet(name):
    for scalet in requests.get('https://api.vscale.io/v1/scalets', headers=headers).json():
        if scalet['name'] == name:
            return scalet
    return {}

for host in ['node1', 'node2', 'node3']:
    if get_scalet(host) == {}:
        print("Start server {}".format(host))
        requests.post("https://api.vscale.io/v1/scalets", headers=headers,
                      json={"make_from": "centos_7_64_001_master",
                            "rplan": "large", "do_start": True,
                            "name": host, "keys":[18823],
                            "location": "spb0"})
    while (get_scalet(host)['status'] != 'started'):
        time.sleep(1)
    with open("kubespray/inventory/vscale/hosts.ini") as f:
        new_ip = f.read().replace('{}_ip'.format(host), get_scalet(host)['public_address']['address'])
        f.close()
    with open("kubespray/inventory/vscale/hosts.ini", "w") as f:
        f.write(new_ip)
        f.close()