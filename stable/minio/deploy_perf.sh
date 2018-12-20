#!/usr/bin/env bash

# clusterExec.py -m perf-k8s-worker{01..04} -- 'sudo mkdir /mnt/minio1 /mnt/minio2'

if [ "`whoami`" != "root" ]; then
    echo "ERROR: you must be root to run this script!"
    exit 1
fi

kubectl create -f stable/minio/gdc-pv-perf.yaml

helm install stable/minio/ --name minio-cluster-1 -f stable/minio/gdc-values-perf.yaml
helm install stable/minio/ --name minio-cluster-2 -f stable/minio/gdc-values-perf.yaml
