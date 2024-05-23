#!/bin/bash
local_ip="127.0.0.1"
dest_ip="10.14.0.5"
public_server="salauser@linuxadmin.sk"

#params: source_port, dest_port
function do_port_forward {
  local port
  port_forward_exists=`ps -ef | grep "$dest_ip:$2:$local_ip:$1" | grep -v grep`
  #do port_forward only when there is still not an active port_forward for source port
  if [[ -z "$port_forward_exists" ]]; then
    logger "DO-PORT-FORWARD: Port forward for $1 port"
    ssh -N -R $dest_ip:$2:$local_ip:$1 $public_server &
  fi
}

#Prometheus
do_port_forward 9090 9090
#Grafana
do_port_forward 3000 3000
