##  1. Commands to execute on host(server) + local(PC)
```
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
```

## 2. Host (Linux server)
```
sudo apt install ansible
```

## 3. Local PC
```
sudo apt install ansible-core
```

### a) generate default config /etc/ansible/ansible.cfg
```
ansible-config init --disabled > ansible.cfg
```

### b) set ansible as remote user in ansible.cfg file
```
remote_user=ansible
```

### c) add ansible hosts file /etc/ansible/hosts
```
[servers]
salaserver ansible_host=192.168.0.201
[vms]
k8smaster ansible_host=192.168.0.202
k8sworker01 ansible_host=192.168.0.211
k8sworker02 ansible_host=192.168.0.212
k8sworker03 ansible_host=192.168.0.213
```

### d) for the first time execute `01-initial-setup.yaml` playbook under default installed sudoer user using password authentication
```
ansible-playbook 01-initial-setup.yaml --ask-become-pass -u <adminuser>
```

### e) next run can be executed using dedicated `ansible` user
```
ansible-playbook salaserver/01-initial-setup.yaml
ansible-playbook salaserver/02-docker.yaml
ansible-playbook salaserver/03-kvm.yaml

#create control-plane node
ansible-playbook salaserver/04-ubuntu-vm-preparation.yaml --extra-vars "@vars/control-plane.yaml"
--or--
#create worker01 node
ansible-playbook salaserver/04-ubuntu-vm-preparation.yaml --extra-vars "@vars/worker01.yaml"
--or--
#create worker02 node
ansible-playbook salaserver/04-ubuntu-vm-preparation.yaml --extra-vars "@vars/worker02.yaml"
--or--
#create worker03 node
ansible-playbook salaserver/04-ubuntu-vm-preparation.yaml --extra-vars "@vars/worker03.yaml"
```

## 4. Configuration of VMs
### a) Create manually new VMs
### !!! Important: skip this step if VMs were created in previous step using ansible scripts !!!

  - follow KVM commands

  https://github.com/fsklenar/ansible/blob/main/kvm-commands.md#creation-of-vms---control-plane-worker-nodes

  - add `memoryBacking` into VM
  ```
  virsh edit <domain>
  ```

  To be able to exchange data, the memory of the guest has to be allocated as “shared”. To do so you need to add the following to the guest config:

  ```
    <memoryBacking>
      <access mode='shared'/>
    </memoryBacking>
  ```

  For performance reasons (it helps virtiofs, but also is generally wise to consider) it
  is recommended to use huge pages which then would look like:

  ```
    <memoryBacking>
      <hugepages>
        <page size='2048' unit='KiB'/>
      </hugepages>
      <access mode='shared'/>
    </memoryBacking>
  ```

  - attach virtiofs disk - used in K8S for Persistent Volumes

    - Create `virtiofs.xml` file

    ```
      <filesystem type='mount' accessmode='passthrough'>
        <driver type='virtiofs'/>
        <binary path='/usr/libexec/virtiofsd'/>
        <source dir='/srv/data/virtiofs'/>
        <target dir='sharedfs'/>
      </filesystem>
    ```

    - Attach device into domain

    ```
      virsh attach-device --config <domain> --file virtiofs.xml
    ```

### b) run first playbooks towards vms
```
ansible-playbook salaserver/01-initial-setup.yaml -u root -l <server_name>
ansible-playbook salaserver/02-docker.yaml -l <server_name>
```

### c) finish k8s preparation
```
ansible-playbook k8s-vms/01-vm-initial-setup.yaml
```

### d) reboot VM
```
virsh reboot <domain>
```

### e) SSH Connect to `control-plane` and add root's public key to public accessible server (example.com) - used for port-forwarding
```
sudo -i  #switch to root
ssh-keygen  #generate private/public key
ssh-copy-id user_with_minimal_rights@example.com
```

### f) install Kubernetes or join worker node into existing cluster
- [kubernetes-installation.md](kubernetes-installation.md)

