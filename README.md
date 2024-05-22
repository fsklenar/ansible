
# Deploy Linux server + Kubernetes (control-plane + 2x worker node) in few minutes using Ansible scripts
## Repository with Ansible scripts and steps for:
- bare metal Linux installation
- installation of VMs for Kubernetes nodes (control plane + worker nodes)
- Kubernetes instalation on VMs
  
### Basic installation of tools on clean Linux server (bare metal)
- ansible
- docker
- KVM hypervisor

### Ansible scripts
- network configuration of linux server
- KVM configuration
- downloading Ubuntu cloud image for VMs
- configuration of VMs

### 1. Steps for Linux host server and VMs configuration
- [ansible_installation.md](ansible_installation)
    - [var/common_vars.yaml](var/common_vars) - common variables for ansible scripts

### 2. Steps for Kubernetes installation
- [kubernetes_installation.md](kubernetes_installation.md)

### Tips & tricks when using KVM
- [kvm-commands.md](kvm-commands)
