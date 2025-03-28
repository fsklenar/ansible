#!/bin/bash
dest_ip="10.14.0.5"
public_server="salauser@linuxadmin.sk"

#params: source_port, dest_port
function do_port_forward {
  local port
  port_forward_exists=`ps -ef | grep "$dest_ip:$2:$3:$1" | grep -v grep`
  #do port_forward only when there is still not an active port_forward for source port
  if [[ -z "$port_forward_exists" ]]; then
    logger "DO-PORT-FORWARD: Port forward for source_port=$1, dest_port=$2"
    ssh -N -R $dest_ip:$2:$3:$1 $public_server &
  fi
}


#params: namespace, app_name (label), source_port, dest_port, local_app_ip, kubect_portfward (true/false)
function k8s_port_forward {
  if [ $6 == "true" ]; then #not needed if ingress is in place
    local TMP_POD
    TMP_POD=""
    while [ -z "${TMP_POD}" ]; do
      TMP_POD="$(kubectl get pods --namespace $1 -l "app.kubernetes.io/name=$2" --field-selector=status.phase==Running --output jsonpath="{.items[0].metadata.name}")"
      #echo "pod=${TMP_POD}"
      sleep 10
    done

    sleep 20  #delay - to be sure pod is running

    logger "K8S-PORT-FORWARD: Port forward for pod=${TMP_POD}, namespace=$1, app=$2, source_port=$3, dest_port=$4"

    kubectl port-forward -n $1 ${TMP_POD} $3:$4 &
  fi

  sleep 5

  do_port_forward $3 $4 $5
}



#Grafana
k8s_port_forward monitoring grafana 3000 3000 "10.192.168.202" false

#Prometheus
#k8s_port_forward monitoring prometheus 9090 9090 "10.192.168.202" false

#Webapp DEV
#k8s_port_forward null null 8090 8090 "10.192.168.202" false

#WordPress DEV
#k8s_port_forward null null 8091 8091 "10.192.168.202" false

#Kibana
#k8s_port_forward null null 5601 5601 "10.192.168.202" false
kubectl port-forward service/eck-kibana-kb-http -n elastic-system 5601:5601 &
do_port_forward 5601 5601 "127.0.0.1"

#Dashboard
kubectl port-forward service/kubernetes-dashboard-kong-proxy -n kubernetes-dashboard 8443:443 &
do_port_forward 8443 8443 "127.0.0.1"

#ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8092:80 &
do_port_forward 8092 8092 "127.0.0.1"

#Kubernetes
do_port_forward 80 8899 "192.168.0.202"

