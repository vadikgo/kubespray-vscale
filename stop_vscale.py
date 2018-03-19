#!/usr/bin/env python3

import requests
import json
import sys

if len(sys.argv) != 2:
    print("define api token")
    sys.exit(1)

token = sys.argv[1]
headers = {"Content-Type": "application/json;charset=UTF-8", "X-Token": token}

def get_scalet(name):
    for scalet in requests.get('https://api.vscale.io/v1/scalets', headers=headers).json():
        if scalet['name'] == name:
            return scalet
    return {}

for host in ['node1', 'node2', 'node3']:
    try:
        requests.delete("https://api.vscale.io/v1/scalets/{}".format(get_scalet(host)['ctid']), headers=headers)
        print ("Host {} deleted.".format(host))
    except KeyError:
        pass
