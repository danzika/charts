#!/usr/bin/env bash

export NAMESPACE=minio

helm del --purge --namespace ${NAMESPACE} minio-cluster-1
helm del --purge --namespace ${NAMESPACE} minio-cluster-2

# If corrupted
kubectl delete pods,services,secrets,configmaps,persistentvolumeclaims,statefulsets.apps --namespace ${NAMESPACE} -l release=minio-cluster-1
kubectl delete persistentvolumes --namespace ${NAMESPACE} -l app=minio

kubectl delete pvc export-minio-cluster-1-0 --namespace ${NAMESPACE}
kubectl delete pvc export-minio-cluster-1-1
kubectl delete pvc export-minio-cluster-1-2
kubectl delete pvc export-minio-cluster-1-3
kubectl delete pvc export-minio-cluster-2-0
kubectl delete pvc export-minio-cluster-2-1
kubectl delete pvc export-minio-cluster-2-2
kubectl delete pvc export-minio-cluster-2-3

kubectl delete -f gdc-pv-perf.yaml --namespace ${NAMESPACE}

clusterExec.py -m perf-k8s-worker{01..08} -- 'sudo rm -rf /mnt/minio1'
