#!/usr/bin/env bash


kubectl create -f gdc-pv-ii.yaml

helm install stable/minio/ --name minio-cluster-1 -f stable/minio/gdc-values-ii.yaml
helm install stable/minio/ --name minio-cluster-2 -f stable/minio/gdc-values-ii.yaml
