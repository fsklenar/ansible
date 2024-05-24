# Ansible scripts for Linux servers and Kubernetes instalation

---
# Deploy Linux server + Kubernetes  in few minutes using Ansible scripts
## Repository with Ansible scripts and steps for:
- Linux installation - bare metal
- Installation of VMs for Kubernetes nodes (control plane + worker nodes)
- Kubernetes instalation on VMs
- Installation of basic tools to Kubernetes cluster
  

### 1. Steps for Linux host server and VMs configuration
- [ansible_installation.md](ansible-installation.md)
    - [vars/common_vars.yaml](vars/common_vars.yaml) - common variables for ansible scripts

### 2. Steps for Kubernetes installation
- [kubernetes_installation.md](kubernetes-installation.md)

### Tips & tricks when using KVM
- [kvm-commands.md](kvm-commands.md)
