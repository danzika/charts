#!/usr/bin/env bash

ssh mgmt-performance

clusterExec.py -m perf-k8s-worker{01..08} -- 'sudo mkdir -p /mnt/minio1'

ssh perf-k8s-master01
sudo -i

kubectl create -f stable/minio/gdc-pv-perf.yaml

###############################################################3
# Cluster 1
###############################################################3

# Without federation
helm install stable/minio/ --name minio-cluster-1 \
  --set service.nodePort=32080 \
  -f stable/minio/gdc-values.yaml

# With federation
helm install stable/minio/ --name minio-cluster-1 \
  --set service.nodePort=32080 \
  --set environment.MINIO_ETCD_ENDPOINTS=http://perf-k8s-master01.int.na.prodgdc.com:2379 \
  --set environment.MINIO_DOMAIN=minio.k8s.gdc.com \
  --set environment.MINIO_PUBLIC_IPS=minio-cluster-1 \
  -f stable/minio/gdc-values.yaml

###############################################################3
# Cluster 2
###############################################################3

# Without federation
helm install stable/minio/ --name minio-cluster-2 \
  --set service.nodePort=32081 \
  -f stable/minio/gdc-values.yaml

# With federation
helm install stable/minio/ --name minio-cluster-2 \
  --set service.nodePort=32081 \
  --set environment.MINIO_ETCD_ENDPOINTS=http://perf-k8s-master01.int.na.prodgdc.com:2379 \
  --set environment.MINIO_DOMAIN=minio.k8s.gdc.com
  -f stable/minio/gdc-values.yaml


# TODO - deploy Ingress with nginx controller like in Hackaton
# Use same port for all Minio clusters
# Consider to (do not) use federation mode

kubectl create -f stable/minio/temp_ingress_nginx.yaml
