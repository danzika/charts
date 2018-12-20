#!/usr/bin/env bash

# clusterExec.py -m ii-k8s-worker{01..04} -- 'sudo mkdir /mnt/minio1 /mnt/minio2'
# clusterExec.py -m perf-k8s-worker{05..08} -- 'sudo mkdir /mnt/minio1 /mnt/minio2'

if [ "`whoami`" != "root" ]; then
    echo "ERROR: you must be root to run this script!"
    exit 1
fi

kubectl create -f stable/minio/gdc-pv-ii.yaml
# kubectl create -f stable/minio/gdc-pv-perf.yaml

# Override values using cmd arguments, e.g. --set persistence.size=100Gi
helm install stable/minio/ --name minio-cluster-1 -f stable/minio/gdc-values.yaml
helm install stable/minio/ --name minio-cluster-2 -f stable/minio/gdc-values.yaml

#####################################
# Purge
helm del --purge minio-cluster-1

kubectl delete pvc export-minio-cluster-1-0
kubectl delete pvc export-minio-cluster-1-1
kubectl delete pvc export-minio-cluster-1-2
kubectl delete pvc export-minio-cluster-1-3
kubectl delete pvc export-minio-cluster-2-0
kubectl delete pvc export-minio-cluster-3-1
kubectl delete pvc export-minio-cluster-4-2
kubectl delete pvc export-minio-cluster-5-3

kubectl delete -f stable/minio/gdc-pv-ii.yaml
# kubectl delete -f stable/minio/gdc-pv-perf.yaml

