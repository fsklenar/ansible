### Kubernetes init - creation of K8S cluter
```
kubeadm init --control-plane-endpoint 192.168.0.202 --apiserver-advertise-address 192.168.0.202 --pod-network-cidr=10.244.0.0/16
```
### Flannel installation - overlay network provider
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

### Allow pods on control-plane (optional)
```
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

### Join new worker node into K8S cluster (run on worker nodes)
```
kubeadm join 192.168.0.202:6443 --token <token> \
	--discovery-token-ca-cert-hash sha256:<cert>
```
### Configuration on control-plane
**Important note**
- replace values of `dest_ip` and `public_server` in [k8s-vms/scripts/do-port-forward.sh](k8s-vms/scripts/do-port-forward.sh) file,
	if you want to forward your applications into public server - useful, when your home Internet does not have public IP
```
ansible-playbook k8s-vms/02-vm-kube-config.yaml
```
### Continue with tool installation on K8S cluster

- follow instructions in https://github.com/fsklenar/k8s-salaserver/blob/main/README.md

