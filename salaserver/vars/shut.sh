#!/bin/bash
virsh shutdown k8sworker03
virsh shutdown k8sworker02
virsh shutdown k8sworker01
virsh shutdown k8smaster
sync
sleep 120
sync
if [[ $1 = "reboot" ]]; then
  sudo reboot
else
  sudo shutdown -h now
fi
