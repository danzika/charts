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
kubectl delete pvc export-minio-cluster-3-1
kubectl delete pvc export-minio-cluster-4-2
kubectl delete pvc export-minio-cluster-5-3

kubectl delete -f stable/minio/gdc-pv-ii.yaml

clusterExec.py -m ii-k8s-worker{01..02} -- 'sudo rm -rf /mnt/minio1 /mnt/minio2 /mnt/minio3 /mnt/minio4'
