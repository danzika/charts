#!/usr/bin/env bash

ssh mgmt-develop
clusterExec.py -m ii-k8s-worker{01..02} -- 'sudo mkdir -p /mnt/minio1 /mnt/minio2 /mnt/minio3 /mnt/minio4'

ssh ii-k8s-master01
sudo -i

kubectl create -f stable/minio/gdc-pv-ii.yaml

# Override values using cmd arguments, e.g. --set persistence.size=100Gi
helm install stable/minio/ --name minio-cluster-1 -f stable/minio/gdc-values.yaml
helm install stable/minio/ --name minio-cluster-2 -f stable/minio/gdc-values.yaml

