# kubespray-vscale

## Deploy kubernetes in vscale cloud.

```bash
./start_vscale.py [vscale api token]
./deploy.sh
export KUBECONFIG=~/.kube/vscale
kubectl get nodes
kubectl get pods --all-namespaces
...
./stop_vscale.py [vscale api token]
```

## test single node in vagrant

```bash
cp inventory/Vagrantfile kubespray/
rm -rf kubespray/inventory/*
cp -r inventory/single kubespray/inventory/
cd kubespray/
vagrant up
```