
## Repository with scripts and steps for:
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
- downloading Ubuntu cloud image for VMS and basic configuration
- follow "ansible_installation" file
- "var/common_vars" file - common variables for ansible scripts
- "kvm-commands" file - tips & trick when workling with KVM

### Steps for Kubernetes installation
- follow "kubernetes_installation" file

