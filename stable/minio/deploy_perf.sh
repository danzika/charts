#!/usr/bin/env bash

clusterExec.py -m perf-k8s-worker{01..08} -- 'sudo mkdir -p /mnt/minio1 /mnt/minio2'

ssh perf-k8s-master01
sudo -i

# kubectl create -f stable/minio/gdc-pv-perf.yaml
kubectl create -f stable/minio/gdc-pv-perf-v2.yaml

# Override values using cmd arguments, e.g. --set persistence.size=100Gi
helm install stable/minio/ --name minio-cluster-1 --set persistence.size=200Gi -f stable/minio/gdc-values.yaml
#helm install stable/minio/ --name minio-cluster-2 --set persistence.size=201Gi -f stable/minio/gdc-values.yaml
# Or the same size, if there is only one minio node per worker
helm install stable/minio/ --name minio-cluster-2 --set persistence.size=200Gi -f stable/minio/gdc-values.yaml

# Upgrade
helm upgrade stable/minio/ --name minio-cluster-1 --set persistence.size=200Gi -f stable/minio/gdc-values.yaml


# Temporary, original Ingress does expose random port
kubectl create -f stable/minio/temp_ingress_nginx.yaml

#####################################
# Purge
helm del --purge minio-cluster-1
helm del --purge minio-cluster-2

kubectl delete pvc export-minio-cluster-1-0
kubectl delete pvc export-minio-cluster-1-1
kubectl delete pvc export-minio-cluster-1-2
kubectl delete pvc export-minio-cluster-1-3
kubectl delete pvc export-minio-cluster-2-0
kubectl delete pvc export-minio-cluster-2-1
kubectl delete pvc export-minio-cluster-2-2
kubectl delete pvc export-minio-cluster-2-3

#kubectl delete -f stable/minio/gdc-pv-perf.yaml
kubectl create -f stable/minio/gdc-pv-perf-v2.yaml

