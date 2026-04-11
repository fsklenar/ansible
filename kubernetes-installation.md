### Kubernetes init - creation of K8S cluter
```
kubeadm init --control-plane-endpoint 192.168.0.202 --apiserver-advertise-address 192.168.0.202 --pod-network-cidr=10.244.0.0/16
```


## Overlay network provider - Flannel or Calico

### Flannel installation
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

### Cilium installation
https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/

```
#Example
helm upgrade -i cilium cilium/cilium   --version 1.19.2   --namespace kube-system   -f cilium.yaml
```

```
#Cilium uninstall - TBD
helm uninstall cilium cilium/cilium   --namespace kube-system

```


### Allow pods on control-plane (optional - not recommended)
```
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

### Join new worker node into K8S cluster (run on all worker nodes)
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

### CoreDNS

```
  wget https://raw.githubusercontent.com/coredns/deployment/refs/heads/master/kubernetes/deploy.sh
  
  chmod u+x deploy.sh

  ./deploy.sh | kubectl apply -f -
  kubectl delete --namespace=kube-system deployment kube-dns
```

### - Fix Kubeproxy alert


The metrics bind address of kube-proxy is default to `127.0.0.1:10249` that prometheus instances cannot access to. You should expose metrics by changing `metricsBindAddress` field value to `0.0.0.0:10249` if you want to collect them.

Depending on the cluster, the relevant part `config.conf` will be in ConfigMap kube-system/kube-proxy or kube-system/kube-proxy-config. For example:

```
kubectl -n kube-system edit cm kube-proxy
```
```
apiVersion: v1
data:
  config.conf: |-
    apiVersion: kubeproxy.config.k8s.io/v1alpha1
    kind: KubeProxyConfiguration
    # ...
    # metricsBindAddress: 127.0.0.1:10249
    metricsBindAddress: 0.0.0.0:10249
    # ...
  kubeconfig.conf: |-
    # ...
kind: ConfigMap
metadata:
  labels:
    app: kube-proxy
  name: kube-proxy
  namespace: kube-system
```

### - Similarly fix **Kube scheduler**, **Kube controller** and **etcd** alerts
- SSH login into control-plane node
```
cd /etc/kubernetes/manifests
```
- change ``` - --bind-address=127.0.0.1``` in `kube-scheduler.yaml` file to ``` - --bind-address=0.0.0.0```
- change ``` - --bind-address=127.0.0.1``` in `kube-controller-manager.yaml` file to ``` - --bind-address=0.0.0.0```
- change ``` - --listen-metrics-urls=http://127.0.0.1:2381``` in `etcd.yaml` file to ``` - --listen-metrics-urls=http://0.0.0.0:2381```



