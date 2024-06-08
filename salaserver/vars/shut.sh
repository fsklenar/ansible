#!/bin/bash
virsh shutdown k8sworker02
virsh shutdown k8sworker01
virsh shutdown k8smaster
sync
sleep 120
sync
sudo shutdown -h now
