#!/bin/bash
virsh shutdown k8sworker02
virsh shutdown k8sworker01
virsh shutdown k8smaster
sleep 120
sync
shutdown -h now
