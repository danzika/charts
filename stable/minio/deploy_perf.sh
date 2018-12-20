#!/usr/bin/env bash


kubectl create -f gdc-pv.yaml

helm install stable/minio/ --name minio-cluster-1 -f stable/minio/gdc-values-perf.yaml
