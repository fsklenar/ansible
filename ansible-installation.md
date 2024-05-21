##  Commands to execute on host(server) + local(PC)
```
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
```

## Host (Linux server)
```
sudo apt install ansible
```

## Local machine only
```
sudo apt install ansible-core
```

### generate default config /etc/ansible/ansible.cfg
```
ansible-config init --disabled > ansible.cfg
```

### set ansible as remote user in ansible.cfg file
```
remote_user=ansible
```

### add ansible hosts file /etc/ansible/hosts
```
[servers]
salaserver ansible_host=192.168.0.201
[vms]
k8smaster ansible_host=192.168.0.202
k8sworker01 ansible_host=192.168.0.211
k8sworker01 ansible_host=192.168.0.212
```

### add root's public key to public accessible server (example.com) - used for port-forwarding
```
sudo -i  #switch to root
ssh-keygen  #generate private/public key
ssh-copy-id ubuntu@example.com
```

### run first time 01-initial-setup playbook under default installed sudoer user with password
```
ansible-playbook 01-initial-setup.yaml --ask-become-pass -u <adminuser>
```

### next run can be executed without user 
```
ansible-playbook salaserver/01-initial-setup.yaml
ansible-playbook salaserver/02-docker.yaml
ansible-playbook salaserver/03-kvm.yaml

ansible-playbook salaserver/04-ubuntu-vm-preparation.yaml --extra-vars "@vars/control-plane.yaml"
--or--
ansible-playbook salaserver/04-ubuntu-vm-preparation.yaml --extra-vars "@vars/worker01.yaml"
--or--
ansible-playbook salaserver/04-ubuntu-vm-preparation.yaml --extra-vars "@vars/worker02.yaml"
```

## configuration of VMs
### start VM
```
virsh start <domain>
```

### run first playbook towards vms
```
ansible-playbook salaserver/01-initial-setup.yaml -u root -l <server_name>
ansible-playbook salaserver/02-docker.yaml -l <server_name>
```

### finish k8s preparation
```
ansible-playbook k8s-vms/01-vm-initial-setup.yaml
```

### reboot VM
```
virsh reboot <domain>
```

### install Kubernetes or join worker node into existing cluster
- folow "kubernetes-installation.md" file

