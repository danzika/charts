#!/usr/bin/env bash

export NAMESPACE=minio

kubectl create --namespace ${NAMESPACE} -f gdc-pv-ii.yaml

export CLUSTER_NAME="minio-cluster-1"
export PORT=32080

# Without federation, NodePort
helm install ../minio/ --name ${CLUSTER_NAME} --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.type=NodePort --set service.nodePort=${PORT}
