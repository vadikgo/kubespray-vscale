#!/bin/bash
set -e

cd kubespray || exit 1

ansible all -i inventory/vscale/hosts.ini -m setup

ansible all -i inventory/vscale/hosts.ini -m systemd -a "name=firewalld state=stopped enabled=False"

ansible-playbook -v -i inventory/vscale/hosts.ini cluster.yml -e @inventory/vscale/extravars.yml

ansible node1 -m fetch -a "src=/root/.kube/config dest=~/.kube/vscale flat=true" -i inventory/vscale/hosts.ini

echo "export KUBECONFIG=~/.kube/vscale"
echo "kubectl get nodes"

