# Common KVM commands, tips & tricks

### delete existing domain including deleting of storage 
virsh undefine k8smaster --remove-all-storage

### run VM domain
virt-install -n k8smaster \
--description "Control plane K8s" \
--osinfo=ubuntu24.04 \
--os-variant=ubuntu24.04 \
--memory=6144 \
--vcpus=2 \
--disk path=/srv/data/img/ubuntu-01.img \
--network network=bridged-network \
--import \
--virt-type kvm \
--graphics none \
--wait 0

virt-install -n k8sworker01 \
--description "Worker01 K8s" \
--osinfo=ubuntu24.04 \
--os-variant=ubuntu24.04 \
--memory=6144 \
--vcpus=2 \
--disk path=/srv/data/img/ubuntu-worker-01.img \
--network network=bridged-network \
--import \
--virt-type kvm \
--graphics none \
--wait 0

virt-install -n k8sworker02 \
--description "Worker02 K8s" \
--osinfo=ubuntu24.04 \
--os-variant=ubuntu24.04 \
--memory=6144 \
--vcpus=2 \
--disk path=/srv/data/img/ubuntu-worker-02.img \
--network network=bridged-network \
--import \
--virt-type kvm \
--graphics none \
--wait 0

### connect to vm console
virsh --connect qemu:///system console <domain>

### autostart of domain
virsh autostart <domain>
