#!/usr/bin/env bash

export NAMESPACE=minio

kubectl create --namespace ${NAMESPACE} -f gdc-pv-perf.yaml

###############################################################3
# Cluster 1
###############################################################3

# Without federation
helm install ../minio/ --name minio-cluster-1 --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.nodePort=32080

# Upgrade example
helm upgrade minio-cluster-1 ../minio/ --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.nodePort=32080

# With federation
helm install ../minio/ --name minio-cluster-1 --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.nodePort=32080 \
  --set environment.MINIO_ETCD_ENDPOINTS=http://perf-k8s-master01.int.na.prodgdc.com:2379 \
  --set environment.MINIO_DOMAIN=minio.k8s.gdc.com \
  --set environment.MINIO_PUBLIC_IPS=minio-cluster-1

# Upgrade example
helm upgrade minio-cluster-1 ../minio/ --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.nodePort=32080 \
  --set environment.MINIO_ETCD_ENDPOINTS=http://perf-k8s-master01.int.na.prodgdc.com:2379 \
  --set environment.MINIO_DOMAIN=minio.k8s.gdc.com \
  --set environment.MINIO_PUBLIC_IPS=minio-cluster-1


###############################################################3
# Cluster 2
###############################################################3

# Without federation
helm install ../minio/ --name minio-cluster-2 --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.nodePort=32081 \

# With federation
helm install ../minio/ --name minio-cluster-2 --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.nodePort=32081 \
  --set environment.MINIO_ETCD_ENDPOINTS=http://perf-k8s-master01.int.na.prodgdc.com:2379 \
  --set environment.MINIO_DOMAIN=minio.k8s.gdc.com


# TODO - deploy Ingress with nginx controller like in Hackaton
# Use same port for all Minio clusters
# Consider to (do not) use federation mode

kubectl create --namespace ${NAMESPACE} -f temp_ingress_nginx.yaml
