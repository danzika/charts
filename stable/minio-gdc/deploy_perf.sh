#!/usr/bin/env bash

export NAMESPACE=minio

export NODE_PORT=32080
export SERVICE_PORT=9000

kubectl create --namespace ${NAMESPACE} -f gdc-pv-perf.yaml

helm install ../minio/ --name minio-4node-200G-c01 --namespace ${NAMESPACE} -f minio-4node-200G-c01.yaml
helm install ../minio/ --name minio-4node-200G-c01 --namespace ${NAMESPACE} -f minio-4node-200G-c01.yaml


export CLUSTER_NAME="minio-cluster-1"
export CLUSTER_NAME="minio-cluster-2"

# Without federation, NodePort - DEPRECATED
helm install ../minio/ --name ${CLUSTER_NAME} --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.type=NodePort --set service.nodePort=${NODE_PORT}
# Upgrade example
#helm upgrade ${CLUSTER_NAME} ../minio/ --namespace ${NAMESPACE} -f gdc-values.yaml \
#  --set service.type=NodePort --set service.nodePort=${NODE_PORT}

# Without federation, ingress with default nginx
helm install ../minio/ --name ${CLUSTER_NAME} --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.type=ClusterIP --set service.port=${SERVICE_PORT} \
  --set ingress.enabled=true --set ingress.path=/

# Without federation, without ingress, because ingress from another minio is used (must be updated)
helm install ../minio/ --name ${CLUSTER_NAME} --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.type=ClusterIP --set service.port=${SERVICE_PORT} \
  --set ingress.enabled=false

# Upgrade example
helm upgrade ${CLUSTER_NAME} ../minio/ --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.type=ClusterIP --set service.port=${SERVICE_PORT} \
  --set ingress.enabled=true --set ingress.path=/

# TODO - how to specify path rule for each Vertica?

#######################################################################################
# Actual deployment
export NAMESPACE=minio
export SERVICE_PORT=9000

helm install ../minio/ --name minio-cluster-1 --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.type=ClusterIP --set service.port=${SERVICE_PORT} \
  --set ingress.enabled=true \
  --set ingress.hosts="[perf-dss-v03.minio.k8s.gooddata,perf-dss-v04.minio.k8s.gooddata]"

# Upgrade
helm upgrade minio-cluster-1 ../minio/ --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.type=ClusterIP --set service.port=${SERVICE_PORT} \
  --set ingress.enabled=true \
  --set ingress.hosts="[perf-dss-v03.minio.k8s.gooddata,perf-dss-v04.minio.k8s.gooddata]"

helm install ../minio/ --name minio-cluster-2 --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.type=ClusterIP --set service.port=${SERVICE_PORT} \
  --set ingress.enabled=true --set ingress.hosts="[perf-dss-v03.minio.k8s.gooddata,perf-dss-v04.minio.k8s.gooddata]"



# With federation, NodePort
helm install ../minio/ --name ${CLUSTER_NAME} --namespace ${NAMESPACE} -f gdc-values.yaml \
  --set service.nodePort=${PORT} \
  --set environment.MINIO_ETCD_ENDPOINTS=http://perf-k8s-master01.int.na.prodgdc.com:2379 \
  --set environment.MINIO_DOMAIN=minio.k8s.gdc.com \
  --set environment.MINIO_PUBLIC_IPS=minio-cluster-1


########################################################################
# TODO - deploy Ingress with custom nginx controller like in Hackaton
# Use same port for all Minio clusters
# Consider to (do not) use federation mode

kubectl create --namespace ${NAMESPACE} -f temp_ingress_nginx.yaml
