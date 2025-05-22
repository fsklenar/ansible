# Common KVM commands, tips & tricks

### Documentation

https://ubuntu.com/server/docs/libvirt

### delete existing domain including deleting of storage 
```
virsh undefine k8smaster --remove-all-storage
```

### Creation of VMs - control-plane, worker nodes
```
virt-install -n k8smaster \
--description "Control plane K8s" \
--osinfo=ubuntu24.04 \
--os-variant=ubuntu24.04 \
--memory=4096 \
--memorybacking hugepages=yes \
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
--memory=8192 \
--memorybacking hugepages=yes \
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
--memorybacking hugepages=yes \
--memory=8192 \
--vcpus=2 \
--disk path=/srv/data/img/ubuntu-worker-02.img \
--network network=bridged-network \
--import \
--virt-type kvm \
--graphics none \
--wait 0

virt-install -n k8sworker03 \
--description "Worker03 K8s" \
--osinfo=ubuntu24.04 \
--os-variant=ubuntu24.04 \
--memorybacking hugepages=yes \
--memory=8192 \
--vcpus=2 \
--disk path=/srv/data/img/ubuntu-worker-03.img \
--network network=bridged-network \
--import \
--virt-type kvm \
--graphics none \
--wait 0
```

### connect to VM console
```
virsh --connect qemu:///system console <domain>
```

### autostart of domain
```
virsh autostart <domain>
```

### How to mount a qcow2 disk image
-------------------------------

This is a quick guide to mounting a qcow2 disk images on your host server. This is useful to reset passwords,
edit files, or recover something without the virtual machine running.

**Step 1 - Enable NBD on the Host**

    modprobe nbd max_part=8

**Step 2 - Connect the QCOW2 as network block device**

    qemu-nbd --connect=/dev/nbd0 /var/lib/vz/images/100/vm-100-disk-1.qcow2

**Step 3 - Find The Virtual Machine Partitions**

    fdisk /dev/nbd0 -l

**Step 4 - Mount the partition from the VM**

    mount /dev/nbd0p1 /mnt/somepoint/

**Step 5 - After you done, unmount and disconnect**

    umount /mnt/somepoint/
    qemu-nbd --disconnect /dev/nbd0
    rmmod nbd


