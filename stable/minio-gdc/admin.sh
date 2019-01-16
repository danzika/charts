#!/usr/bin/env bash

wget https://dl.minio.io/client/mc/release/linux-amd64/mc
chmod 775 mc
./mc config host add minio-cluster-1 http://perf-k8s-worker01.int.na.prodgdc.com:32080 \
  vertica_eon_k1234567 vertica_eon_k1234567_secret1234567890123 S3v4
./mc config host add minio-cluster-2 http://perf-k8s-worker04.int.na.prodgdc.com:32081 \
  vertica_eon_k1234567 vertica_eon_k1234567_secret1234567890123 S3v4
./mc admin info minio-cluster-1
./mc ls minio-cluster-1

./mc mb minio-cluster-2/test2
./mc mirror minio-cluster-1/test minio-cluster-2/test2

# Explore / modify ETCD records
export ETCDCTL_API=3
etcdctl --endpoints perf-k8s-master01.int.na.prodgdc.com:2379 get --prefix /skydns

# Delete key
etcdctl --endpoints perf-k8s-master01.int.na.prodgdc.com:2379 \
  del /skydns/com/gdc/k8s/minio/test/172.19.32.4
etcdctl --endpoints perf-k8s-master01.int.na.prodgdc.com:2379 \
  del /skydns/com/gdc/k8s/minio/test2/172.17.48.8


# TODO - think about to modify IP to redirect bucket to different Minio cluster
# would have to be done in sync with "mc -w mirror" operation
etcdctl --endpoints perf-k8s-master01.int.na.prodgdc.com:2379 \
  put /skydns/com/gdc/k8s/minio/test/172.19.32.4 \
  "{\"host\":\"172.17.48.8\",\"port\":9000,\"ttl\":30,\"creationDate\":\"2019-01-10T11:21:08.03322357Z\"}"


