#!/usr/bin/env bash

ssh mgmt-performance

ssh perf-k8s-master01
sudo -i

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

kubectl delete -f stable/minio/gdc-pv-perf.yaml

clusterExec.py -m perf-k8s-worker{01..08} -- 'sudo rm -rf /mnt/minio1'
